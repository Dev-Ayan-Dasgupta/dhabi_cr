import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapDownloadFdCertificate {
  static Future<Map<String, dynamic>> mapDownloadFdCertificate(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await DownloadFdCertificate.downloadFdCertificate(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
