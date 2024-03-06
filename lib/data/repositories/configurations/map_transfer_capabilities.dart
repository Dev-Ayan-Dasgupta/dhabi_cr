import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapTransferCapabilities {
  static Future<Map<String, dynamic>> mapTransferCapabilities() async {
    try {
      http.Response response =
          await GetTransferCapabilities.getTransferCapabilities();
      if (response.statusCode != 200) {
        log("getTransferCapabilities Status Code -> ${response.statusCode}");
      }
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
