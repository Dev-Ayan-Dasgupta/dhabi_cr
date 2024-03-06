import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/corporateOnboarding/index.dart';
import 'package:http/http.dart' as http;

class MapIfTradeLicenseExists {
  static Future<bool> mapIfTradeLicenseExists(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await CheckIfTradeLicenseExists.checkIfTradeLicenseExists(
              body, token);
      return jsonDecode(response.body)["exists"];
    } catch (_) {
      rethrow;
    }
  }
}
