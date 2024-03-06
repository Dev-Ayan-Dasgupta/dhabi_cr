import 'package:dialup_mobile_app/data/models/arguments/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';

class InvestNationInterceptor implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    request.headers.addAll({'Content-Type': 'application/json; charset=UTF-8'});
    request.headers.addAll(
        {'Authorization': 'Bearer ${await storage.read(key: "token")}'});
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    if (response.statusCode == 401) {
      isUserLoggedIn = false;
      // Show session timeout message
      showAdaptiveDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return CustomDialog(
            svgAssetPath: ImageConstants.warning,
            title: "Session Time Out",
            message:
                "Your current session has timed out, please login to continue.",
            actionWidget: GradientButton(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.loginPassword,
                  (route) => false,
                  arguments: LoginPasswordArgumentModel(
                    emailId: storageEmail ?? "",
                    userId: storageUserId ?? 0,
                    userTypeId: storageUserTypeId ?? 1,
                    companyId: storageCompanyId ?? 0,
                    isSwitching: false,
                  ).toMap(),
                );
              },
              text: "Login",
            ),
          );
        },
      );
      // And take the customer to the login screen
    } else if (response.statusCode == 500) {
      showAdaptiveDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return CustomDialog(
            svgAssetPath: ImageConstants.warning,
            title: "Status code 500",
            message: "System failure, something went wrong.",
            actionWidget: GradientButton(
              onTap: () {
                Navigator.pop(context);
              },
              text: "Login",
            ),
          );
        },
      );
    } else if (response.statusCode != 200 && response.statusCode != 401) {
      // Something went wrong from the API system
      showAdaptiveDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return CustomDialog(
            svgAssetPath: ImageConstants.warning,
            title: "System Failure",
            message: "System failure, something went wrong.",
            actionWidget: GradientButton(
              onTap: () {
                Navigator.pop(context);
              },
              text: "Login",
            ),
          );
        },
      );
      // Show System Error message
    }
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() async {
    return true;
  }

  @override
  Future<bool> shouldInterceptResponse() async {
    return true;
  }
}
