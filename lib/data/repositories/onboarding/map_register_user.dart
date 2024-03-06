import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/onboarding/index.dart';
import 'package:http/http.dart' as http;

class MapRegisterUser {
  static Future<Map<String, dynamic>> mapRegisterUser(
      Map<String, dynamic> body) async {
    try {
      http.Response response = await RegisterUser.registerUser(body);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
