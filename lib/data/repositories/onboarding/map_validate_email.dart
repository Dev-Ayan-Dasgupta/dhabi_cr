import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/onboarding/index.dart';
import 'package:http/http.dart' as http;

class MapValidateEmail {
  static Future<Map<String, dynamic>> mapValidateEmail(
      Map<String, dynamic> body) async {
    try {
      http.Response response = await ValidateEmail.validateEmail(body);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
