import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/corporateAccounts/index.dart';
import 'package:http/http.dart' as http;

class MapChangeEmailAddress {
  static Future<Map<String, dynamic>> mapChangeEmailAddress(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await ChangeEmailAddress.changeEmailAddress(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
