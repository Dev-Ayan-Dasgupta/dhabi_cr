import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/payments/index.dart';
import 'package:http/http.dart' as http;

class MapInter {
  static Future<Map<String, dynamic>> mapInter(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response = await MakeInter.makeInter(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
