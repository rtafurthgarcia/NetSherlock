import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class Helpers {
  static bool isPlateformValidForQr() {
    if (Platform.isAndroid) {
      return true;
    } else if (Platform.isIOS) {
      return true;
    } else if (Platform.isMacOS) {
      return true;
    } else if (kIsWeb) {
      return true;
    } else {
      return false;
    }
  }
}