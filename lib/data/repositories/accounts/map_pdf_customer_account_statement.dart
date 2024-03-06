import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapPdfCustomerAccountStatement {
  static Future<Map<String, dynamic>> mapPdfCustomerAccountStatement(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await GetPdfCustomerAccountStatement.getPdfCustomerAccountStatement(
              body, token);
      if (response.statusCode == 401) {
        log("401 error");
      }
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
