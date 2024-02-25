import 'package:flutter_secure_storage/flutter_secure_storage.dart';
enum ShodanState { initial, loading, unauthenticated, authenticated, error, ok }

class Shared {
  static const String API_URI = "https://api.shodan.io";
  static const int MAX_SCREEN_WIDTH = 540;
  static const API_KEY_SETTINGS = "key";

  static const FlutterSecureStorage storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    )
  );

  static String apiKey = ""; 
}
