import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/corporateAccounts/index.dart';
import 'package:http/http.dart' as http;

class MapCorporateFdApprovalList {
  static Future<Map<String, dynamic>> mapCorporateFdApprovalList(
      String token) async {
    try {
      http.Response response =
          await GetCorporateFdApprovalList.getCorporateFdApprovalList(token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
