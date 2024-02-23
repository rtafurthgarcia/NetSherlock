import 'package:netsherlock/models/shodan_account_model.dart';
import 'package:netsherlock/models/shodan_alert_model.dart';

import 'package:netsherlock/shared.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:netsherlock/services/shodan_account_service.dart';

class ShodanAPIProvider {
  static Future<ShodanAccount> fetchAccountDetails({required String apiKey}) async {
    String? errorMessage = ShodanAccountService.validateApiKey(apiKey);
    if (errorMessage != null) {
      throw ArgumentError(errorMessage);
    }

    final response = await http.get(
      Uri.parse("${Shared.API_URI}/api-info?key=$apiKey"),
      /*headers: {
        HttpHeaders.authorizationHeader: apiKey,
      },*/
    );
    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    ShodanAccount account = ShodanAccount.fromJson(responseJson);

    return account;
  }

  static Future<List<ShodanAlert>> fetchLatestAlerts({required String apiKey}) async {
    final response = await http.get(
      Uri.parse("${Shared.API_URI}/shodan/alert/info?key=$apiKey"),
    );
    final responseJson = jsonDecode(response.body);
    List<ShodanAlert> shodanAlerts = List<ShodanAlert>.from(responseJson.map((model)=> ShodanAlert.fromJson(model)));

    return shodanAlerts;
  }
}