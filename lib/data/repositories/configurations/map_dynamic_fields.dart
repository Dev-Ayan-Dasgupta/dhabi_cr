import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapDynamicFields {
  static Future<Map<String, dynamic>> mapDynamicFields(
      Map<String, dynamic> body) async {
    try {
      http.Response response = await GetDynamicFields.getDynamicFields(body);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
