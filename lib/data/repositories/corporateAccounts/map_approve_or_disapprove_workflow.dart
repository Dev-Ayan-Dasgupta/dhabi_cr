import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/corporateAccounts/index.dart';
import 'package:http/http.dart' as http;

class MapApproveOrDissaproveWorkflow {
  static Future<Map<String, dynamic>> mapApproveOrDissaproveWorkflow(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await ApproveOrDisapproveWorkflow.approveOrDisapproveWorkflow(
              body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
