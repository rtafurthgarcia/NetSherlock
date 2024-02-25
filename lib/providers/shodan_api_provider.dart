import 'dart:io';

import 'package:netsherlock/models/new_shodan_asset_model.dart';
import 'package:netsherlock/models/shodan_account_model.dart';
import 'package:netsherlock/models/shodan_asset_model.dart';

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
    );
    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    ShodanAccount account = ShodanAccount.fromJson(responseJson);

    return account;
  }

  static Future<List<ShodanAsset>> fetchMonitoredAssets() async {
    final response = await http.get(
      Uri.parse("${Shared.API_URI}/shodan/alert/info?key=${Shared.apiKey}"),
    );
    final responseJson = jsonDecode(response.body);
    List<ShodanAsset> shodanAlerts = List<ShodanAsset>.from(responseJson.map((model)=> ShodanAsset.fromJson(model)));

    return shodanAlerts;
  }

  static Future<ShodanAsset> postAsset(NewShodanAsset asset) async {
    final body = asset.toJsonString();

    final response = await http.post(
      Uri.parse("${Shared.API_URI}/shodan/alert?key=${Shared.apiKey}"),
      body: body
    );
    if (response.statusCode != 200) {
      throw const HttpException("Could not create our new asset");
    } else {
      final responseJson = jsonDecode(response.body);
      return ShodanAsset.fromJson(responseJson);
    }
  }

  static Future<void> deleteAsset(String assetId) async {
    final response = await http.delete(
      Uri.parse("${Shared.API_URI}/shodan/alert/$assetId?key=${Shared.apiKey}"),
    );
    if (response.statusCode != 200) {
      throw const HttpException("Could not delete our asset");
    } 
  }
}