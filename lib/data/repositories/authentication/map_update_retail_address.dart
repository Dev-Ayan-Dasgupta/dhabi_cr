import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/authentication/index.dart';
import 'package:http/http.dart' as http;

class MapUpdateRetailAddress {
  static Future<Map<String, dynamic>> mapUpdateRetailAddress(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await UpdateRetailAddress.updateRetailAddress(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
