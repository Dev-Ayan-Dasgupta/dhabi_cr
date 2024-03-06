import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/onboarding/index.dart';
import 'package:http/http.dart' as http;

class MapUploadPassport {
  static Future<Map<String, dynamic>> mapUploadPassport(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response = await UploadPassport.uploadPassport(body, token);
      if (response.statusCode != 200) {
        log("Status Code Upload Passport -> ${response.statusCode}");
      }
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
