import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/authentication/index.dart';
import 'package:http/http.dart' as http;

class MapProfileData {
  static Future<Map<String, dynamic>> mapProfileData(String token) async {
    try {
      http.Response response = await GetProfileData.getProfileData(token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
