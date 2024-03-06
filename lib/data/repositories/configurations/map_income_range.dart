import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapIncomeRange {
  static Future<Map<String, dynamic>> mapIncomeRange() async {
    try {
      http.Response response = await GetIncomeRange.getIncomeRange();
      if (response.statusCode != 200) {
        log("API getIncomeRange Status Code -> ${response.statusCode}");
      }
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
