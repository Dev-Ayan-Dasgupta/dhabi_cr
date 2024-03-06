import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/onboarding/index.dart';
import 'package:http/http.dart' as http;

class MapRegisterRetailCustomer {
  static Future<Map<String, dynamic>> mapRegisterRetailCustomer(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await RegisterRetailCustomer.registerRetailCustomer(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
