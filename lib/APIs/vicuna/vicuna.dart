import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:Echo/APIs/vicuna/llm_models.dart';
import 'package:Echo/utils/console.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class VicunaAPI {
  static int _objResIndex = 0;
  static double temp = 0.7;
  static int maxOutputLength = 4000;
  static String ans = "";
  static late String _sessionHash;
  static late IOWebSocketChannel _channel;
  static const String _soc = 'wss://chat.lmsys.org/queue/join';
  static late Map<String, dynamic> _payload;

  static Map<String, dynamic> _composeHashPayload(int fnIndex) {
    return {'fn_index': fnIndex, "session_hash": _sessionHash};
  }

  static Map<String, dynamic> _addPayloadData(List<dynamic> data) {
    _payload['data'] = data;
    _payload['event_data'] = null;
    return _payload;
  }

  static void initSession() {
    _sessionHash = _genSessionHash();
    _channel = IOWebSocketChannel.connect(_soc);
    _payload = _composeHashPayload(10);

    _channel.stream.listen((event) {
      event = jsonDecode(event);

      switch (event['msg']) {
        case 'send_hash':
          _channel.sink.add(jsonEncode(_payload));
          break;
        case 'send_data':
          _addPayloadData([{}]);
          _channel.sink.add(jsonEncode(_payload));
          break;
        case 'process_completed':
          _channel.sink.close(status.normalClosure);
          break;

        default:
      }
    }, onError: (error) {
      Console.logError(error);
      _channel.sink.close(status.abnormalClosure);
    });
  }

  static Future<String> queryLanguageModel(String prompt) {
    Completer<String> completer = Completer<String>();
    _channel = IOWebSocketChannel.connect(_soc);
    _payload = _composeHashPayload(8);
    _channel.sink.add(jsonEncode(_payload));

    _channel.stream.listen((event) {
      event = jsonDecode(event);

      switch (event['msg']) {
        case "send_data":
          _addPayloadData([null, prompt]);
          _channel.sink.add(jsonEncode(_payload));
          break;
        case "process_completed":
          _channel.sink.close(status.normalClosure);

          _fetchModelResults().then(
            (value) {
              completer.complete(value);
            },
          );

          break;
      }
    }, onError: (error) {
      Console.logError(error);
      _channel.sink.close(status.abnormalClosure);
    });

    return completer.future;
  }

  static Future<String> _fetchModelResults() {
    Completer<String> completer = Completer<String>();

    _channel = IOWebSocketChannel.connect(_soc);
    _payload = _composeHashPayload(9);
    _channel.sink.add(jsonEncode(_payload));

    _channel.stream.listen((encodedevent) {
      var event = jsonDecode(encodedevent);

      switch (event['msg']) {
        case "send_data":
          _addPayloadData([null, LLMModels.vicuna, temp, maxOutputLength]);
          _channel.sink.add(jsonEncode(_payload));
          break;
        case "process_completed":
          Console.log(encodedevent);
          _channel.sink.close(status.normalClosure);
          Console.log(event['output']);
          ans = _extractText(event['output']['data'][1][_objResIndex][1]);
          // ans = event['output']['data'][1][_objResIndex][1];
          Console.log(ans);
          _objResIndex++;
          completer.complete(ans);
          break;
      }
    }, onError: (error) {
      Console.logError(error);
      _channel.sink.close(status.abnormalClosure);
      completer.completeError(error);
    });

    return completer.future;
  }

  static String _extractText(String htmlStr) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlStr.replaceAll(exp, '');
  }

  static String _genSessionHash() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(11, (index) => chars[random.nextInt(chars.length)])
        .join();
  }
}
