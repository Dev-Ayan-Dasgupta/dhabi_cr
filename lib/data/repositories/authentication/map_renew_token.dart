import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/authentication/index.dart';
import 'package:http/http.dart' as http;

class MapRenewToken {
  static Future<Map<String, dynamic>> mapRenewToken(String token) async {
    try {
      http.Response response = await RenewToken.renewToken(token);
      if (response.statusCode == 401) {
        log("Renew Token Auth error 401");
      }
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
