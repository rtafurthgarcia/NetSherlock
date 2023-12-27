import 'package:flutter/widgets.dart';
import 'package:netsherlock/models/shodan_account_model.dart';
import 'package:netsherlock/providers/shodan_account_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ShodanAccountState { initial, loading, authenticated, error }

class ShodanAccountService extends ChangeNotifier {
  static const API_KEY_SETTINGS = "key";

  ShodanAccountState _state = ShodanAccountState.initial;
  String _apiKey = "";
  dynamic _error;
  ShodanAccount? shodanAccount;

  String get apiKey => _apiKey;
  ShodanAccountState get state => _state;
  dynamic get error => _error;

  void setApiKey(String newApiKey) async {
    if (newApiKey == apiKey) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(API_KEY_SETTINGS, newApiKey);

    _apiKey = newApiKey;
    
    final validationMessage = validateApiKey(apiKey);
    if (validationMessage == null) {
      _state = ShodanAccountState.initial;
      _error = null;
    } else {
      _state = ShodanAccountState.error;
      _error = validationMessage;
    }

    notifyListeners();
  }

  static String? validateApiKey(String apiKey) {
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
    _state = ShodanAccountState.loading;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString(API_KEY_SETTINGS) ?? "";

    if (_apiKey.isEmpty) {
      _state = ShodanAccountState.initial;
      notifyListeners();
      return;
    }

    final validationMessage = validateApiKey(_apiKey);
    if (validationMessage != null) {
      _error = validationMessage;
      _state = ShodanAccountState.error;
      notifyListeners();
      return;
    }

    try {
      shodanAccount =
          await ShodanAccountProvider.fetchAccountDetails(apiKey: apiKey);

      _state = ShodanAccountState.authenticated;
    } catch (exception) {
      _state = ShodanAccountState.error;
      _error = exception;
    }

    notifyListeners();
  }
}
