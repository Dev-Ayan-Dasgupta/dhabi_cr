import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/payments/index.dart';
import 'package:http/http.dart' as http;

class MapInternationalMoneyTransferv2 {
  static Future<Map<String, dynamic>> mapInternationalMoneyTransferv2(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response = await MakeInternationalMoneyTransferV2
          .makeInternationalMoneyTransferV2(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
