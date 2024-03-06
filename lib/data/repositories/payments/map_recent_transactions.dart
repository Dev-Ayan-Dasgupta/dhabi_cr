import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/payments/index.dart';
import 'package:http/http.dart' as http;

class MapRecentTransactions {
  static Future<Map<String, dynamic>> mapRecentTransactions(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await GetRecentTransactions.getRecentTransactions(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
