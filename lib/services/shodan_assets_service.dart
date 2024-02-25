import 'package:flutter/widgets.dart';
import 'package:netsherlock/providers/shodan_api_provider.dart';
import 'package:netsherlock/shared.dart';
import 'package:netsherlock/models/shodan_asset_model.dart';

class ShodanAlertsService extends ChangeNotifier {
  ShodanServiceState _state = ShodanServiceState.loading;
  dynamic _error;

  List<ShodanAsset>? alerts;

  ShodanServiceState get state => _state;
  dynamic get error => _error;

  ShodanAlertsService() { 
    loadAlerts();
  }

  void loadAlerts() async {
    if (Shared.apiKey.isEmpty) {
      _state = ShodanServiceState.unauthenticated;
      notifyListeners();
      return;
    }

     try {
      alerts = await ShodanAPIProvider.fetchMonitoredAssets();

      _state = ShodanServiceState.ok;
    } catch (exception) {
      _state = ShodanServiceState.error;
      _error = exception;
    }

    notifyListeners();
  }
}