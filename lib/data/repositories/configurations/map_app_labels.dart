import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/configurations/get_app_labels.dart';
import 'package:http/http.dart' as http;

class MapAppLabels {
  static Future<List> mapAppLabels(Map<String, dynamic> body) async {
    try {
      http.Response response = await GetAppLabels.getAppLabels(body);
      return jsonDecode(response.body)["labels"];
    } catch (_) {
      rethrow;
    }
  }
}
