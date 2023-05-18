import 'package:Echo/screens/chat_screen.dart';
import 'package:Echo/services/tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Echo/APIs/bard/bard.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  ChatScreen.initres = await BardAPI.queryLanguageModel("Hi");
  await TTS.initTTS();

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Main(),
  ));
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return const ChatScreen();
  }
}
