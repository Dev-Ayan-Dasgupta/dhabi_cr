import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/onboarding/index.dart';
import 'package:http/http.dart' as http;

class MapIfPassportExists {
  static Future<Map<String, dynamic>> mapIfPassportExists(
    Map<String, dynamic> body,
    String token,
  ) async {
    try {
      http.Response response =
          await IfPassportExists.ifPassportExists(body, token);
      if (response.statusCode != 200) {
        log("Status code -> ${response.statusCode}");
      }
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
