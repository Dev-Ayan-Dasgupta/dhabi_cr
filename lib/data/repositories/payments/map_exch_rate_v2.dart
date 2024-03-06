import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/payments/index.dart';
import 'package:http/http.dart' as http;

class MapExchangeRateV2 {
  static Future<Map<String, dynamic>> mapExchangeRateV2(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await GetExchangeRateV2.getExchangeRateV2(body, token);
      log("getExchangeRateV2 Status Code -> ${response.statusCode}");
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
