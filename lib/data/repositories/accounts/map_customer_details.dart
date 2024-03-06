import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapCustomerDetails {
  static Future<Map<String, dynamic>> mapCustomerDetails(String token) async {
    try {
      http.Response response =
          await GetCustomerDetails.getCustomerDetails(token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
