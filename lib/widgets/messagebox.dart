import 'package:Echo/APIs/bard/bard.dart';
import 'package:Echo/screens/chat_screen.dart';
import 'package:Echo/utils/console.dart';
import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  final Function() scroll;
  final Function() setstate;

  static bool isButtonEnabled = true;

  const MessageBox({
    Key? key,
    required this.setstate,
    required this.scroll,
  }) : super(key: key);

  static final TextEditingController textcon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: 1,
      maxLines: 5,
      controller: MessageBox.textcon,
      decoration: InputDecoration(
        hintText: 'Type your question...',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.send, color: Color.fromARGB(255, 119, 8, 205)),
          onPressed:
              _sendFromTextField, // Disable the button when isButtonEnabled is false
        ),
      ),
    );
  }

  Future<void> _sendFromTextField() async {
    isButtonEnabled = false;
    setstate();

    if (MessageBox.textcon.text == "" || MessageBox.textcon.text == " ") {
      MessageBox.textcon.text = '';
      isButtonEnabled = true;
      return setstate();
    }

    var text = removeSpecialCharacters(MessageBox.textcon.text);

    ChatScreen.addMessgaes('User', textcon.text);

    MessageBox.textcon.text = '';
    setstate();
    scroll();

    ChatScreen.addMessgaes('Echo', await BardAPI.queryLanguageModel(text));

    setstate();
    scroll();
    isButtonEnabled = true; // Enable the button
    setstate();
  }

  static String removeSpecialCharacters(String text) {
    final Map<String, String> specialCharacters = {
      r'\\': '',
      '\\': '',
      r'\"': '',
      r"\'": '',
      r'\n': '',
      r'\r': '',
      r'\t': '',
      r'\b': '',
      r'\f': '',
      r'"': '',
      r"'": '',
      r'\v': '',
      r'\a': '',
      r'\0': '',
      r'\xHH': '',
      r'\[': '',
      r'\]': '',
    };

    String sanitizedText = text;
    specialCharacters.forEach((key, value) {
      sanitizedText = sanitizedText.replaceAll(key, value);
    });

    sanitizedText = sanitizedText.replaceAll(RegExp(r'[\r\n]+'), '');


    Console.log(sanitizedText // Remove line breaks
        );
    return sanitizedText;
  }
}
