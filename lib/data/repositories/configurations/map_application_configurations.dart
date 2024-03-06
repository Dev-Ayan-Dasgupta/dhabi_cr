import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapApplicationConfigurations {
  static Future<Map<String, dynamic>> mapApplicationConfigurations() async {
    try {
      http.Response response =
          await GetApplicationConfigurations.getApplicationConfigurations();
      if (response.statusCode != 200) {
        log("API Response Status Code -> ${response.statusCode}");
      }
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
