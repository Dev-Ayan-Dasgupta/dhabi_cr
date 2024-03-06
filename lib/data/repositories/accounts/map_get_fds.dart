import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapGetFds {
  static Future<Map<String, dynamic>> mapGetFds(String token) async {
    try {
      http.Response response = await GetFdRates.getFdRates(token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
