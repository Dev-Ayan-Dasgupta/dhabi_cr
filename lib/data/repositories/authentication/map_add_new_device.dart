import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/authentication/index.dart';
import 'package:http/http.dart' as http;

class MapAddNewDevice {
  static Future<Map<String, dynamic>> mapAddNewDevice(
      Map<String, dynamic> body) async {
    try {
      http.Response response = await AddNewDevice.addNewDevice(body);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
