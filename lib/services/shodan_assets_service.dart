import 'package:flutter/widgets.dart';
import 'package:netsherlock/models/new_shodan_asset_model.dart';
import 'package:netsherlock/providers/shodan_api_provider.dart';
import 'package:netsherlock/shared.dart';
import 'package:netsherlock/models/shodan_asset_model.dart';

class ShodanAssetsService extends ChangeNotifier {
  ShodanState _state = ShodanState.loading;
  dynamic _error;

  List<ShodanAsset> assets = [];

  ShodanState get state => _state;
  dynamic get error => _error;

  ShodanAssetsService() { 
    loadAssets();
  }

  void loadAssets() async {
    _state = ShodanState.loading;
    notifyListeners();

    if (Shared.apiKey.isEmpty) {
      _state = ShodanState.unauthenticated;
      notifyListeners();
      return;
    }

    try {
      assets = await ShodanAPIProvider.fetchMonitoredAssets();

      _state = ShodanState.ok;
    } catch (exception) {
      _state = ShodanState.error;
      _error = exception;
    }

    notifyListeners();
  }

  Future<void> createAsset(NewShodanAsset asset) async {
    _state = ShodanState.loading;
    notifyListeners();

     if (Shared.apiKey.isEmpty) {
      _state = ShodanState.unauthenticated;
      notifyListeners();
      return;
    }

    try {
      final newAsset = await ShodanAPIProvider.postAsset(asset);
      assets.add(newAsset);

      _state = ShodanState.ok;
    } catch (exception) {
      _state = ShodanState.error;
      _error = exception;
    }

    notifyListeners();
  }

  Future<void> deleteAsset(String assetId) async {
    _state = ShodanState.loading;
    notifyListeners();

     if (Shared.apiKey.isEmpty) {
      _state = ShodanState.unauthenticated;
      notifyListeners();
      return;
    }

    try {
      await ShodanAPIProvider.deleteAsset(assetId);
      assets.removeWhere((asset) => asset.id == assetId);

      _state = ShodanState.ok;
    } catch (exception) {
      _state = ShodanState.error;
      _error = exception;
    }

    notifyListeners();
  }
}