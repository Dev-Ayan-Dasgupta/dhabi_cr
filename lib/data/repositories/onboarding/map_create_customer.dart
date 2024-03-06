import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/onboarding/index.dart';
import 'package:http/http.dart' as http;

class MapCreateCustomer {
  static Future<Map<String, dynamic>> mapCreateCustomer(String token) async {
    try {
      http.Response response = await CreateCustomer.createCustomer(token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
