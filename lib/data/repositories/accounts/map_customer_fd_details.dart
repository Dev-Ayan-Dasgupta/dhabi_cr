import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapCustomerFdDetails {
  static Future<Map<String, dynamic>> mapCustomerFdDetails(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await GetCustomerFdDetails.getCustomerFdDetails(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
