import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/payments/index.dart';
import 'package:http/http.dart' as http;

class MapExchangeRate {
  static Future<Map<String, dynamic>> mapExchangeRate(String token) async {
    try {
      http.Response response = await GetExchangeRate.getExchangeRate(token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
