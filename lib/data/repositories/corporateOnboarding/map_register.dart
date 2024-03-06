import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/corporateOnboarding/index.dart';
import 'package:http/http.dart' as http;

class MapRegister {
  static Future<Map<String, dynamic>> mapRegister(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response = await Register.register(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
