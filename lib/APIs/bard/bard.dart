import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Echo/utils/console.dart';
import 'package:http/http.dart' as http;

class BardAPI {
  static const String _endpoint =
      'https://bard.google.com/_/BardChatUi/data/assistant.lamda.BardFrontendService/StreamGenerate';

  static Future<String> queryLanguageModel(String prompt) async {
    var headers = {
      'content-type': 'application/x-www-form-urlencoded;charset=UTF-8',
      'cookie': '__Secure-3PSID=${dotenv.get("3PSID")};',
    };

    var body =
        "f.req=%5Bnull%2C%22%5B%5B%5C%22$prompt%5C%5Cn%5C%22%5D%2Cnull%2C%5B%5C%22c_c%5C%22%2C%5C%22r_c%5C%22%2C%5C%22rc_c%5C%22%5D%5D%22%5D&at=${dotenv.get('AT')}";

    var res =
        await http.post(Uri.parse(_endpoint), headers: headers, body: body);


    return _getResponse(res.body);
  }

  static String _getResponse(String res) {
    res = res.substring(5);
    var text = jsonDecode(res);
    text = jsonDecode(text[0][2])[0].toString();
    Console.log(text);
    return text.replaceAll(RegExp(r'[\[\]]'), '');
  }
}
