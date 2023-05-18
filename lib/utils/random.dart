import 'package:flutter/material.dart';

Future<void> wait(int seconds)async {
  await Future.delayed(Duration(seconds: seconds));  
}

void snackbar(BuildContext context, String text, int duration) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    dismissDirection: DismissDirection.up,
    content: Text(text),
    duration: Duration(seconds: duration),
  ));
}