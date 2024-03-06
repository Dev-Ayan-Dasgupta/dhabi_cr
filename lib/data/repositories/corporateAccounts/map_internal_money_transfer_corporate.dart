import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/corporateAccounts/index.dart';
import 'package:http/http.dart' as http;

class MapInternalMoneyTransferCorporate {
  static Future<Map<String, dynamic>> mapInternalMoneyTransferCorporate(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response = await MakeInternalMoneyTransferCorporate
          .makeInternalMoneyTransferCorporate(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
