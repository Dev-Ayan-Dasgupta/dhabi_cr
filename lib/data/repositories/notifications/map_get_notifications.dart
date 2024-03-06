import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/notifications/index.dart';
import 'package:http/http.dart' as http;

class MapGetNotifications {
  static Future<Map<String, dynamic>> mapGetNotifications(String token) async {
    try {
      http.Response response = await GetNotifications.getNotifications(token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
