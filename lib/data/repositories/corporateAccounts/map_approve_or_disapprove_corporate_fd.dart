import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/corporateAccounts/index.dart';
import 'package:http/http.dart' as http;

class MapApproveOrDisapproveCorporateFd {
  static Future<Map<String, dynamic>> mapApproveOrDisapproveCorporateFd(
      String token) async {
    try {
      http.Response response =
          await ApproveOrDisapproveCorporateFd.approveOrDisapproveCorporateFd(
              token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
