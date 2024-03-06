import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/interceptor_contract.dart';
import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class GetFdPrematureWithdrawalDetails {
  static Future<http.Response> getFdPrematureWithdrawalDetails(
      Map<String, dynamic> body, String token) async {
    try {
      final appHttp = InterceptedClient.build(interceptors: [
        InvestNationInterceptor(),
      ]);
      return appHttp.post(
        Uri.parse(Environment().config.getFdPrematureWithdrawalDetails),
        body: jsonEncode(body),
      );
    } catch (_) {
      rethrow;
    }
  }
}
