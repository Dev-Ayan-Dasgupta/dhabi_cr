import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapCreateAccount {
  static Future<Map<String, dynamic>> mapCreateAccount(
      Map<String, dynamic> body) async {
    try {
      http.Response response = await CreateAccount.createAccount(body);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
