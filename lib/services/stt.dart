// import 'package:Echo/utils/console.dart';
// import 'package:Echo/utils/random.dart';
// import 'package:Echo/widgets/messagebox.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

// class STT {
//   static String recorded = "";
//   static bool listening = false;
//   static bool initSuc = false;
//   static final stt.SpeechToText _speech = stt.SpeechToText();

//   static Future<void> initSTT() async {
//     initSuc = await _speech.initialize();
//   }

//   static Future<String> listenSTT() async {
//     listening = true;

//     if (!initSuc) return '';

//     await _speech.listen(
//       onResult: (result) {
//         recorded = result.recognizedWords;
//         MessageBox.textcon.text = result.recognizedWords;
//       },
//     );

//     if (listening == false) {
//       MessageBox.textcon.text = "";
//       recorded = '';
//       return '';
//     }

//     await wait(8);

//     if (recorded.isEmpty || listening == false) {
//       MessageBox.textcon.text = "";
//       recorded = '';
//       return '';
//     }

//     listening = false;
//     return recorded;
//   }

//   static Future<void> stopSTT() async {
//     if (listening) {
//       listening = false;
//       await _speech.stop();
//     }
//   }
// }




  // Future<void> _sendRecorded() async {
  //   setState(() {
  //     _isButtonPressed = true;
  //     STT.recorded = '';
  //     MessageBox.textcon.text = '';
  //   });

  //   await STT.listenSTT();
  //   if (STT.recorded.isEmpty) return;

  //   ChatScreen.addMessgaes('User', STT.recorded);

  //   setState(() {
  //     MessageBox.textcon.text = '';
  //   });

  //   scroll();
  //   var res = await BardAPI.queryLanguageModel(STT.recorded);

  //   ChatScreen.addMessgaes('Echo', res);

  //   setState(() {});
  //   await wait(2);
  //   scroll();
  //   _isButtonPressed = false;
  //   setState(() {});

  //   TTS.speak(res);
  // }
