import 'dart:io' show Platform;

class Helpers {
  static bool isPlateformValidForQr() {
    if (Platform.isAndroid) {
      return true;
    } else if (Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }

  static bool isDesktop() {
    if (Platform.isWindows) {
      return true;
    } else if (Platform.isLinux) {
      return true;
    } else if (Platform.isMacOS) {
      return true;
    } else {
      return false;
    }
  }
}
