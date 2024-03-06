import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/onboarding/index.dart';
import 'package:http/http.dart' as http;

class MapSendEmailOtp {
  static Future<Map<String, dynamic>> mapSendEmailOtp(
      Map<String, dynamic> body) async {
    try {
      http.Response response = await SendEmailOtp.sendEmailOtp(body);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
