import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapLoanSchedule {
  static Future<Map<String, dynamic>> mapLoanSchedule(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await GetLoanSchedule.getLoanSchedule(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
