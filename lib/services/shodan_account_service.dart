import 'package:flutter/widgets.dart';
import 'package:netsherlock/models/shodan_account_model.dart';
import 'package:netsherlock/providers/shodan_account_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShodanAccountService extends ChangeNotifier {
  static const API_KEY_SETTINGS = "key";

  bool _isLoading = true;
  bool _isAuthenticated = false;
  String _apiKey = "";
  dynamic _error;
  ShodanAccount? shodanAccount;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String get apiKey => _apiKey;
  dynamic get error => _error;

  void setApiKey(String newApiKey) async {
    if (newApiKey == apiKey) {
      return;
    }

    if (isApiKeyValid(newApiKey) != null) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(API_KEY_SETTINGS, newApiKey);

    _apiKey = newApiKey;
    _error = null;
    notifyListeners();
  }

  static String? isApiKeyValid(String apiKey) {
    if (apiKey.isEmpty) {
      return 'Can\'t be empty';
    }
    if (apiKey.length != 32) {
      return 'Shodan API key is invalid!';
    }

    return null;
  }

  ShodanAccountService() {
    reloadDetails();
  }

  void reloadDetails() async {
    SharedPreferences.getInstance()
        .then((prefs) async {
          _apiKey = prefs.getString(API_KEY_SETTINGS) ?? "";

          if (apiKey.isNotEmpty) {
            return await ShodanAccountProvider.fetchAccountDetails(
                apiKey: apiKey);
          } else {
            _isLoading = false;
          }
        })
        .then((loadedShodanAccount) => shodanAccount = loadedShodanAccount)
        .catchError((error, stackTrace) => _error = error)
        .whenComplete(() {
          if (shodanAccount != null) {
            _isAuthenticated = true;
          }
          _isLoading = false;
          notifyListeners();
        });

    notifyListeners();
  }
}
