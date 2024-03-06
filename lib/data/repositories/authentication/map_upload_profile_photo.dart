import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/authentication/index.dart';
import 'package:http/http.dart' as http;

class MapUploadProfilePhoto {
  static Future<Map<String, dynamic>> mapUploadProfilePhoto(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await UploadProfilePhoto.uploadProfilePhoto(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
