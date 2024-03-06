import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapCreateFd {
  static Future<Map<String, dynamic>> mapCreateFd(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response = await CreateFd.createFd(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
