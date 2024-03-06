import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapTermsAndConditions {
  static Future<String> mapTermsAndConditions(Map<String, dynamic> body) async {
    try {
      http.Response response =
          await GetTermsAndConditions.getTermsAndConditions(body);
      return jsonDecode(response.body)["terms"];
    } catch (_) {
      rethrow;
    }
  }
}
