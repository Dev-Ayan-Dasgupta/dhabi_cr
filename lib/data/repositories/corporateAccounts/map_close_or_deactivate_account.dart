import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/corporateAccounts/index.dart';
import 'package:http/http.dart' as http;

class MapCloseOrDeactivateAccount {
  static Future<Map<String, dynamic>> mapCloseOrDeactivateAccount(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await CloseOrDeactivateAccount.closeOrDeactivateAccount(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
