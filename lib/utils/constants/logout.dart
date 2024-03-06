import 'package:dialup_mobile_app/data/repositories/authentication/index.dart';
import 'package:dialup_mobile_app/utils/constants/token.dart';

class Logout {
  static Future<void> logout() async {
    await MapLogout.mapLogout(token ?? "");
  }
}
