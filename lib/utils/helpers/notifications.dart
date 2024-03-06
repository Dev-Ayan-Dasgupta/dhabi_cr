import 'package:dialup_mobile_app/data/models/arguments/verification_initialization.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/main.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static List<int> checkerNotificationTypes = [3, 6, 9, 12, 15, 18, 21, 24, 27];

  static void requestIOSPermissions(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static void initialize(String messageType, String additionalInformation) {
    const settings = InitializationSettings(
      iOS: IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      ),
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    // initialize notifications plugin
    notificationsPlugin.initialize(
      settings,
      onSelectNotification: (_) {
        // Navigator.pushNamed(context, Routes.depositStatement);
        if (checkerNotificationTypes.contains(int.parse(messageType))) {
          navigatorKey.currentState!.pushNamed(
            Routes.workflowDetails,
            arguments: WorkflowArgumentModel(
              reference: additionalInformation,
              workflowType: int.parse(messageType),
            ).toMap(),
          );
        } else {
          switch (messageType) {
            case "1":
              navigatorKey.currentState!.pushNamed(
                Routes.verificationInitializing,
                arguments: VerificationInitializationArgumentModel(
                  isReKyc: true,
                ).toMap(),
              );
              break;

            case "2":
              navigatorKey.currentState!.pushNamed(
                Routes.splash,
              );
              break;

            default:
              navigatorKey.currentState!.pushNamed(Routes.notifications);
          }
        }
      },
    );
  }

  static void display(RemoteMessage message) {
    try {
      // final id = int.parse(const Uuid().v4());

      notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              "Dhabi",
              "Dhabi name",
              importance: Importance.high,
              enableVibration: true,
              playSound: true,
            ),
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "Dhabi", // this has to be the same as the string passed in the meta-data in AndroidManifest.xml
          "Dhabi Channel",
          playSound: true,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: IOSNotificationDetails(),
      );
      notificationsPlugin.show(
        0,
        // id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: Routes.depositStatement,
      );
    } catch (_) {
      rethrow;
    }
  }
}
