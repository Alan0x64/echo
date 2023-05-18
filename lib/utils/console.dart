import 'package:flutter/foundation.dart';

class Console {
  static logError(String str) {
    return "\n---------------ERROR-------------\n$str\n----------------------------\n";
  }

  static log(dynamic str) {
    if (kDebugMode) {
      print("----------------------------\n$str\n----------------------------");
    }
  }
}
