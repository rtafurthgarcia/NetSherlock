import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:netsherlock/shared.dart';

import 'package:netsherlock/models/shodan_alert_model.dart';

class ShodanAlertsProvider {
  static Future<List<ShodanAlert>> fetchLatestAlerts({required String apiKey}) async {
    final response = await http.get(
      Uri.parse("${Shared.API_URI}/shodan/alert/info?key=$apiKey"),
    );
    final responseJson = jsonDecode(response.body);
    List<ShodanAlert> shodanAlerts = List<ShodanAlert>.from(responseJson.map((model)=> ShodanAlert.fromJson(model)));

    return shodanAlerts;
  }
}