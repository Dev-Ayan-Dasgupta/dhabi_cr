import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/onboarding/index.dart';
import 'package:http/http.dart' as http;

class MapCustomerTaxInformation {
  static Future<Map<String, dynamic>> mapCustomerTaxInformation(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await UploadCustomerTaxInformation.uploadCustomerTaxInformation(
              body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
