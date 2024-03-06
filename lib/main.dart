// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/presentation/routers/app_router.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';

// import 'package:http_proxy/http_proxy.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

List<CameraDescription> cameras = [];

const storage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);

bool forceLogout = false;
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  // HttpProxy httpProxy = await HttpProxy.createHttpProxy();
  // HttpOverrides.global = httpProxy;
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.appRouter,
  });

  final AppRouter appRouter;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of our application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return FlutterSizer(
      builder: (context, orientation, screenType) {
        return screenType == ScreenType.tablet
            ? Column(
                children: [
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: CustomMultiBlocProvider(
                        appRouter: widget.appRouter,
                      ),
                    ),
                  ),
                ],
              )
            : CustomMultiBlocProvider(appRouter: widget.appRouter);
      },
    );
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      Logout.logout();
    }
  }

  @override
  void dispose() {
    Logout.logout();
    super.dispose();
  }
}
