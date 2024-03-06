import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/authentication/index.dart';
import 'package:http/http.dart' as http;

class MapUpdateRetailEmailId {
  static Future<Map<String, dynamic>> mapUpdateRetailEmailId(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await UpdateRetailEmailId.updateRetailEmailId(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
