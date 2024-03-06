import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/corporateAccounts/index.dart';
import 'package:http/http.dart' as http;

class MapCorporateCustomerPermissions {
  static Future<Map<String, dynamic>> mapCorporateCustomerPermissions(
      String token) async {
    try {
      http.Response response =
          await GetCorporateCustomerPermissions.getCorporateCustomerPermissions(
              token);
      if (response.statusCode != 200) {
        log("Status Code -> ${response.statusCode}");
      }
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
