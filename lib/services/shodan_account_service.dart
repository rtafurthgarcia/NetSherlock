import 'package:flutter/widgets.dart';
import 'package:netsherlock/models/shodan_account_model.dart';
import 'package:netsherlock/providers/shodan_api_provider.dart';
import 'package:netsherlock/shared.dart';

class ShodanAccountService extends ChangeNotifier {
  ShodanServiceState _state = ShodanServiceState.initial;
  dynamic _error;
  ShodanAccount? shodanAccount;

  ShodanServiceState get state => _state;
  dynamic get error => _error;

  void setApiKey(String newApiKey) async {
    if (newApiKey == Shared.apiKey) {
      return;
    }

    await Shared.storage.write(key: Shared.API_KEY_SETTINGS, value: newApiKey);

    Shared.apiKey = newApiKey;
    
    final validationMessage = validateApiKey(Shared.apiKey);
    if (validationMessage == null) {
      _state = ShodanServiceState.initial;
      _error = null;
    } else {
      _state = ShodanServiceState.error;
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
    load();
  }

  void clearDetails() async {
    _state = ShodanServiceState.loading;
    notifyListeners();

    _state = ShodanServiceState.initial;
    _error = null;
    Shared.apiKey = "";
    await Shared.storage.write(key: Shared.API_KEY_SETTINGS, value: "");

    notifyListeners();
  }

  void load() async {
    _state = ShodanServiceState.loading;
    notifyListeners();

    Shared.apiKey = await Shared.storage.read(key: Shared.API_KEY_SETTINGS) ?? "";

    if (Shared.apiKey.isEmpty) {
      _state = ShodanServiceState.initial;
      notifyListeners();
      return;
    }

    final validationMessage = validateApiKey(Shared.apiKey);
    if (validationMessage != null) {
      _error = validationMessage;
      _state = ShodanServiceState.error;
      notifyListeners();
      return;
    }

    try {
      shodanAccount =
          await ShodanAPIProvider.fetchAccountDetails(apiKey: Shared.apiKey);

      _state = ShodanServiceState.authenticated;
    } catch (exception) {
      _state = ShodanServiceState.error;
      _error = exception;
    }

    notifyListeners();
  }
}
