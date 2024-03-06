import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class OAuthHelper {
  static oAuth() async {
    const FlutterAppAuth appauth = FlutterAppAuth();
    AuthorizationTokenResponse? result;
    try {
      result = await appauth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          "c1310189-34a4-41f3-8d66-0a3229d6d84c",
          "https://example.com/auth/add_oauth_token",
          discoveryUrl:
              "https://login.microsoftonline.com/44dfdab9-90c8-43ce-b10b-058cee531043/v2.0/.well-known/openid-configuration",
          scopes: [
            'openid',
            'profile',
          ],
        ),
      );
      debugPrint("AuthorizationTokenResponse -> $result");
    } catch (e) {
      debugPrint("OAuth Exception -> $e");
    }
  }
}
