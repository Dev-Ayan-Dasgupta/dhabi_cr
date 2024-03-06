import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapCustomerSingleCif {
  static Future<Map<String, dynamic>> mapCustomerSingleCif(
      Map<String, dynamic> body) async {
    try {
      http.Response response =
          await HasCustomerSingleCif.hasCustomerSingleCif(body);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
