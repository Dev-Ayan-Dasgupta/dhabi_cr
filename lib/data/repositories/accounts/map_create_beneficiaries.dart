import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapCreateBeneficiary {
  static Future<Map<String, dynamic>> mapCreateBeneficiary(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await CreateBeneficiary.createBeneficiary(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
