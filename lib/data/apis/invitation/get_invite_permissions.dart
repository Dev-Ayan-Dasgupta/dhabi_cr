import 'package:dialup_mobile_app/data/apis/interceptor_contract.dart';
import 'package:dialup_mobile_app/environment/setup.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class GetInvitationPermissions {
  static Future<http.Response> getInvitationPermissions(String token) async {
    try {
      final appHttp = InterceptedClient.build(interceptors: [
        InvestNationInterceptor(),
      ]);
      return appHttp.post(
        Uri.parse(Environment().config.getInvitationPermissions),
      );
    } catch (_) {
      rethrow;
    }
  }
}
