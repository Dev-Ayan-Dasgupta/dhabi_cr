import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/invitation/index.dart';
import 'package:http/http.dart' as http;

class MapInvitationEmail {
  static Future<Map<String, dynamic>> mapInvitationEmail(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await GetInvitationEmail.getInvitationEmail(body, token);
      if (response.statusCode != 200) {
        log("Status code -> ${response.statusCode}");
      }
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
