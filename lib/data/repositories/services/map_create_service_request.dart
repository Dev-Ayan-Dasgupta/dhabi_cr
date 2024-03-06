import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/services/index.dart';
import 'package:http/http.dart' as http;

class MapCreateServiceRequest {
  static Future<Map<String, dynamic>> mapCreateServiceRequest(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await CreateServiceRequest.createServiceRequest(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
