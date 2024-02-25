import 'package:flutter/widgets.dart';
import 'package:netsherlock/models/shodan_dns_entry.dart';
import 'package:netsherlock/providers/shodan_api_provider.dart';
import 'package:netsherlock/shared.dart';

class ShodanDomainService extends ChangeNotifier {
  ShodanState _state = ShodanState.initial;
  dynamic _error;

  ShodanDNSLookupResult? result;

  ShodanState get state => _state;
  dynamic get error => _error;

  Future<void> lookupDomain(String domain) async {
    _state = ShodanState.loading;
    notifyListeners();

     if (Shared.apiKey.isEmpty) {
      _state = ShodanState.unauthenticated;
      notifyListeners();
      return;
    }

    try {
      result = await ShodanAPIProvider.lookupDomain(domain);

      _state = ShodanState.ok;
    } catch (exception) {
      _state = ShodanState.error;
      _error = exception;
    }

    notifyListeners();
  }
}