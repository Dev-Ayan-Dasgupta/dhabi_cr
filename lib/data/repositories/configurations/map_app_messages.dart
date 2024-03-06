import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapAppMessages {
  static Future<List> mapAppMessages(Map<String, dynamic> body) async {
    try {
      http.Response response = await GetAppMessages.getAppMessages(body);
      return jsonDecode(response.body)["messages"];
    } catch (_) {
      rethrow;
    }
  }
}
