
import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/authentication/index.dart';
import 'package:http/http.dart' as http;

class MapValidateEmailOtpForPassword {
  static Future<Map<String, dynamic>> mapValidateEmailOtpForPassword(
      Map<String, dynamic> body) async {
    try {
      http.Response response =
          await ValidateEmailOtpForPassword.validateEmailOtpForPassword(body);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
