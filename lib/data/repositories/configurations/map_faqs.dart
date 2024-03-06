import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapFaqs {
  static Future<Map<String, dynamic>> mapFaqs() async {
    try {
      http.Response response = await GetFaqs.getFaqs();
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
