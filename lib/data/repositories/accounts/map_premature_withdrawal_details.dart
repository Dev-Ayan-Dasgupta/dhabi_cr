import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapFDPrematureWithdrawalDetails {
  static Future<Map<String, dynamic>> mapFDPrematureWithdrawalDetails(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await GetFdPrematureWithdrawalDetails.getFdPrematureWithdrawalDetails(
              body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
