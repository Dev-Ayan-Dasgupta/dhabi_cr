import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapCountryDetails {
  static Future<List> mapCountryDetails(Map<String, dynamic> body) async {
    try {
      http.Response response = await GetCountryDetails.getCountryDetails(body);
      return jsonDecode(response.body)["countryDetails"]["states"][0]["cities"];
    } catch (_) {
      rethrow;
    }
  }
}
