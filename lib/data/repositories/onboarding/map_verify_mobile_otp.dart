import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/onboarding/index.dart';
import 'package:http/http.dart' as http;

class MapVerifyMobileOtp {
  static Future<Map<String, dynamic>> mapVerifyMobileOtp(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await VerifyMobileOtp.verifyMobileOtp(body, token);
      log("mobile verification response status -> ${response.statusCode}");
      log("response -> ${jsonDecode(response.body)}");
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
