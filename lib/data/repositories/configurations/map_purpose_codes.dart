import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapPurposeCodes {
  static Future<Map<String, dynamic>> mapPurposeCodes() async {
    try {
      http.Response response = await GetPurposeCodes.getPurposeCodes();
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
