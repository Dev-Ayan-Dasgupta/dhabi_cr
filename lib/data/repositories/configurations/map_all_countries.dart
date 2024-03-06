import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/configurations/get_all_countries.dart';
import 'package:http/http.dart' as http;

class MapAllCountries {
  static Future<List> mapAllCountries() async {
    try {
      http.Response response = await GetAllCountries.getAllCountries();
      return jsonDecode(response.body)["dhabiCountries"];
    } catch (_) {
      rethrow;
    }
  }
}
