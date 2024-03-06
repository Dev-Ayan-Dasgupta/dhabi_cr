import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/corporateAccounts/index.dart';
import 'package:http/http.dart' as http;

class MapCorporateCustomerAccountDetails {
  static Future<Map<String, dynamic>> mapCorporateCustomerAccountDetails(
      String token) async {
    try {
      http.Response response = await GetCorporateCustomerAccountDetails
          .getCorporateCustomerAccountDetails(token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
