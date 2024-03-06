import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapGetBeneficiaries {
  static Future<Map<String, dynamic>> mapGetBeneficiaries(String token) async {
    try {
      http.Response response = await GetBeneficiaries.getBeneficiaries(token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
