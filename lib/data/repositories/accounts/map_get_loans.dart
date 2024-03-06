import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapGetLoans {
  static Future<Map<String, dynamic>> mapGetLoans(String token) async {
    try {
      http.Response response = await GetLoans.getLoans(token);
      if (response.statusCode != 200) {
        log("Status Code -> ${response.statusCode}");
      }
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
