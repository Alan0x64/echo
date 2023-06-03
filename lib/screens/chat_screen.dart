// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:Echo/services/tts.dart';
import 'package:Echo/widgets/messagebox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share/share.dart';
import 'package:flutter/services.dart';

import '../utils/random.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static final List<Map<String, String>> messages = [];

  static late String initres;

  @override
  State<ChatScreen> createState() => _ChatScreenState();

  static void addMessgaes(String sender, String text) {
    messages.add({'s': sender, 't': text});
  }
}

class _ChatScreenState extends State<ChatScreen> {
  late String res;

  static final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    ChatScreen.addMessgaes('Echo', ChatScreen.initres);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt_outlined),
            color: Colors.black,
            onPressed: () {
              ChatScreen.messages.clear();
              MessageBox.isButtonEnabled = true;
              TTS.stopTTS();
              setState(() {});
            },
          ),
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.settings),
              color: Colors.black,
              onPressed: () {},
            ),
        ],
        backgroundColor: Colors.white,
        title: const Text(
          'Echo Assistant Experimental',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              itemCount: ChatScreen.messages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(5, 10, 0, 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            image: ChatScreen.messages[index]['s'] == 'Echo'
                                ? const DecorationImage(
                                    image: AssetImage('assets/echo.png'),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: ChatScreen.messages[index]['s'] == 'Echo'
                                ? null
                                : const Color.fromARGB(255, 207, 115,
                                    10), // Replace with your desired background color
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                              child:
                                  ChatScreen.messages[index]['s'].toString() !=
                                          "Echo"
                                      ? const Icon(
                                          Icons.person_outlined,
                                        )
                                      : null),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 221, 220, 220),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              if (ChatScreen.messages[index]['s'] != "Echo")
                                Center(
                                  child: ListTile(
                                      title: SelectableText(
                                    ChatScreen.messages[index]['t'].toString(),
                                  )),
                                ),
                              if (ChatScreen.messages[index]['s'] == "Echo")
                                ListTile(
                                  title: Container(
                                    padding: const EdgeInsets.all(5),
                                    child: MarkdownBody(
                                      styleSheet: MarkdownStyleSheet.fromTheme(
                                              Theme.of(context))
                                          .copyWith(
                                        code: const TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                      data: ChatScreen.messages[index]['t']
                                          .toString(),
                                      selectable: true,
                                    ),
                                  ),
                                ),
                              if (index != 0 &&
                                  ChatScreen.messages[index]['s'] == "Echo")
                                const Divider(
                                  height: 5,
                                ),
                              if (index != 0 &&
                                  ChatScreen.messages[index]['s'] == "Echo")
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        try {
                                          await Clipboard.setData(ClipboardData(
                                              text: makeTextReadyForCopy(
                                                  ChatScreen.messages[index]
                                                          ['t']
                                                      .toString())));

                                          snackbar(context,
                                              "Copied To Clipboard!", 3);
                                        } catch (e) {
                                          snackbar(
                                              context,
                                              "Somthing Went Worng While Coping",
                                              3);
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.copy,
                                        size: 19,
                                      ),
                                    ),
                                    if (getCodeFromMarkdown(ChatScreen
                                            .messages[index]['t']
                                            .toString())
                                        .isNotEmpty)
                                      IconButton(
                                        onPressed: () async {
                                          try {
                                            await Clipboard.setData(
                                                ClipboardData(
                                                    text: getCodeFromMarkdown(
                                                        ChatScreen
                                                            .messages[index]
                                                                ['t']
                                                            .toString())));

                                            snackbar(context,
                                                "Copied To Clipboard!", 3);
                                          } catch (e) {
                                            snackbar(
                                                context,
                                                "Somthing Went Worng While Coping Code",
                                                3);
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.code,
                                          size: 19,
                                        ),
                                      ),
                                    IconButton(
                                      onPressed: () async {
                                        try {
                                          if (!Platform.isIOS &&
                                              !Platform.isAndroid) {
                                            snackbar(
                                                context,
                                                "Sharing Is Not Supported On This Platform",
                                                3);
                                            return;
                                          }
                                          await Share.share(
                                              makeTextReadyForCopy(ChatScreen
                                                  .messages[index]['t']
                                                  .toString()));
                                        } catch (e) {
                                          snackbar(
                                              context,
                                              "Somthing Went Worng Trying To Share",
                                              3);
                                          return;
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.share,
                                        size: 19,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        try {
                                          if (!Platform.isIOS &&
                                              !Platform.isAndroid) {
                                            return snackbar(
                                                context,
                                                "Feature Not Supported On This Platform",
                                                3);
                                          }
                                          if (TTS.speaking) {
                                            await TTS.stopTTS();
                                            TTS.speaking = false;
                                            return setState(() {});
                                          }

                                          var a = removeCodeFromMarkdown(
                                              ChatScreen.messages[index]['t']
                                                  .toString());
                                          TTS.speaking = true;
                                          setState(() {});
                                          await TTS.speak(MessageBox
                                                  .removeSpecialCharacters(a)
                                              .replaceAll('* **', '')
                                              .replaceAll('**', ''));
                                          TTS.speaking = false;
                                          setState(() {});
                                        } catch (e) {
                                          snackbar(
                                              context, "Faild To Read Text", 3);
                                          return;
                                        }
                                      },
                                      icon: Icon(
                                        TTS.speaking
                                            ? Icons.stop
                                            : Icons.volume_up,
                                        size: 19,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: MessageBox.isButtonEnabled
                ? MessageBox(
                    setstate: () {
                      setState(() {});
                    },
                    scroll: scroll,
                  )
                : null,
          ),
        ],
      ),
    );
  }

  static void scroll() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  String makeTextReadyForCopy(String t) {
    var data = t.toString().replaceAll('```', '');
    return data
        .replaceAll("'''", "")
        .replaceAll("* **", "*")
        .replaceAll('**', '');
  }

  String getCodeFromMarkdown(String markdown) {
    RegExp exp = RegExp(r'```(.+)?\n([\s\S]+?)\n```');
    var match = exp.firstMatch(markdown);
    if (match != null) {
      String code = match.group(2)!;
      // Remove language specifier if it exists
      code = code.replaceAll(RegExp(r'^[\s\S]+?\n'), '');
      return code;
    } else {
      return "";
    }
  }

  String removeCodeFromMarkdown(String markdown) {
    RegExp codeBlockExp = RegExp(r'```.*[\s\S]*?```');
    return markdown.replaceAll(codeBlockExp, '');
  }
}
