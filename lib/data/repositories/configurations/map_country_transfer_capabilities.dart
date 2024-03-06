import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapCountryTransferCapabilities {
  static Future<Map<String, dynamic>> mapCountryTransferCapabilities(
      Map<String, dynamic> body) async {
    try {
      http.Response response =
          await GetCountryTransferCapabilities.getCountryTransferCapabilities(
              body);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
