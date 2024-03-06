import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapSupportedLanguages {
  static Future<List> mapSupportedLanguages() async {
    try {
      http.Response response =
          await GetSupportedLanguages.getSupportedLanguages();
      return jsonDecode(response.body)["languages"];
    } catch (_) {
      rethrow;
    }
  }
}
