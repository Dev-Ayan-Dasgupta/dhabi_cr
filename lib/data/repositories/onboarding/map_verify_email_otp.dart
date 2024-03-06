import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/onboarding/index.dart';
import 'package:http/http.dart' as http;

class MapVerifyEmailOtp {
  static Future<Map<String, dynamic>> mapVerifyEmailOtp(
      Map<String, dynamic> body) async {
    try {
      http.Response response = await VerifyEmailOtp.verifyEmailOtp(body);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
