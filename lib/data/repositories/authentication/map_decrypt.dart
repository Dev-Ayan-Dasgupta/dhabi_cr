import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/authentication/index.dart';
import 'package:http/http.dart' as http;

class MapDecrypt {
  static Future<Map<String, dynamic>> mapDecrypt(
      Map<String, dynamic> body) async {
    try {
      http.Response response = await Decrypt.decrypt(body);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
