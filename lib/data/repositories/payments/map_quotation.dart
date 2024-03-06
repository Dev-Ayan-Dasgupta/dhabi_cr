import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/payments/index.dart';
import 'package:http/http.dart' as http;

class MapQuotation {
  static Future<Map<String, dynamic>> mapQuotation(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response = await GetQuotation.getQuotation(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
