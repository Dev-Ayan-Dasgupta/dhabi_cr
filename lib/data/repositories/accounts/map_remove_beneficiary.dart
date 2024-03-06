import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapRemoveBeneficiary {
  static Future<Map<String, dynamic>> mapRemoveBeneficiary(
      Map<String, dynamic> body) async {
    try {
      http.Response response = await RemoveBeneficiary.removeBeneficiary(body);
      if (response.statusCode == 401) {
        log("401 error");
      }
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
