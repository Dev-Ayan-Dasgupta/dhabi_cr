import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/payments/index.dart';
import 'package:http/http.dart' as http;

class MapInternalMoneyTransfer {
  static Future<Map<String, dynamic>> mapInternalMoneyTransfer(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await MakeInternalMoneyTransfer.makeInternalMoneyTransfer(
              body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
