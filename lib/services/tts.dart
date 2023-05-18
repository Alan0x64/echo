import 'package:flutter_tts/flutter_tts.dart';

class TTS {
  static late bool speaking;
  static final FlutterTts _tts = FlutterTts();

  static Future<void> initTTS() async {
    speaking = false;
    await _tts.setVoice({"name": "en-US-language", "locale": "en-US"});
    await _tts.setVolume(0.5);
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.5);
  }

  static Future<void> stopTTS() async {
    if (speaking) {
      await _tts.stop();
      speaking = false;
    }
  }

  static Future<void> speak(String text) async {
    if (text.isEmpty) return;
    await _tts.speak(text);
    await _tts.awaitSpeakCompletion(true);
  }
}
