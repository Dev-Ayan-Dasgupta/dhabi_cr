import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/authentication/index.dart';
import 'package:http/http.dart' as http;

class MapIsDeviceValid {
  static Future<Map<String, dynamic>> mapIsDeviceValid(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response = await IsDeviceValid.isDeviceValid(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
