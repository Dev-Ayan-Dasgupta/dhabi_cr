import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/authentication/index.dart';
import 'package:http/http.dart' as http;

class MapLogout {
  static Future<Map<String, dynamic>> mapLogout(String token) async {
    try {
      http.Response response = await Logout.logout(token);
      log("Status code logout -> ${response.statusCode}");
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
