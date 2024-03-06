import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapImage {
  static Future<String> mapImage(Map<String, dynamic> body) async {
    try {
      http.Response response = await GetImage.getImage(body);
      log("Get Image Status Code -> ${response.statusCode}");
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
