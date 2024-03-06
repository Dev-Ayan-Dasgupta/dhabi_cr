import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/configurations/get_bank_details.dart';
import 'package:http/http.dart' as http;

class MapBankDetails {
  static Future<List<dynamic>> mapBankDetails() async {
    try {
      http.Response response = await GetBankDetails.getBankDetails();
      if (response.statusCode != 200) {
        log("Status code -> ${response.statusCode}");
      }
      return jsonDecode(response.body)["banks"];
    } catch (_) {
      rethrow;
    }
  }
}
