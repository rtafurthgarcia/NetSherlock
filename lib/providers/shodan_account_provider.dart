import 'package:netsherlock/models/shodan_account_model.dart';

import 'package:netsherlock/consts.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:netsherlock/services/shodan_account_service.dart';

class ShodanAccountProvider {
  static Future<ShodanAccount> fetchAccountDetails({required String apiKey}) async {
    String? errorMessage = ShodanAccountService.isApiKeyValid(apiKey);
    if (errorMessage != null) {
      throw ArgumentError(errorMessage);
    }

    final response = await http.get(
      Uri.parse("${Consts.API_URI}/account/profile?key=$apiKey"),
      /*headers: {
        HttpHeaders.authorizationHeader: apiKey,
      },*/
    );
    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    ShodanAccount account = ShodanAccount.fromJson(responseJson);

    return account;
  }
}