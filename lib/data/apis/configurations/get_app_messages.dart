import 'dart:convert';
import 'package:dialup_mobile_app/data/apis/interceptor_contract.dart';
import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class GetAppMessages {
  static Future<http.Response> getAppMessages(Map<String, dynamic> body) async {
    try {
      final appHttp = InterceptedClient.build(interceptors: [
        InvestNationInterceptor(),
      ]);
      return appHttp.post(
        Uri.parse(Environment().config.getAppMessages),
        body: jsonEncode(body),
      );
    } catch (_) {
      rethrow;
    }
  }
}
