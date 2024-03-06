import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/onboarding/index.dart';
import 'package:http/http.dart' as http;

class MapUploadEid {
  static Future<Map<String, dynamic>> mapUploadEid(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response = await UploadEid.uploadEid(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
