import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/corporateAccounts/index.dart';
import 'package:http/http.dart' as http;

class MapWorkflowDetails {
  static Future<Map<String, dynamic>> mapWorkflowDetails(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await GetWorkflowDetails.getWorkflowDetails(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
