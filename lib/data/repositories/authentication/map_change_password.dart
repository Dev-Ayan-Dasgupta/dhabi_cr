import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/authentication/index.dart';
import 'package:http/http.dart' as http;

class MapChangePassword {
  static Future<Map<String, dynamic>> mapChangePassword(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response = await ChangePassword.changePassword(body, token);
      if (response.statusCode != 200) {
        log("Status code -> ${response.statusCode}");
      }
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
