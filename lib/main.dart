import 'package:adv_11_am_firebase_app/helpers/fcm_helper.dart';
import 'package:adv_11_am_firebase_app/helpers/local_notification_helper.dart';
import 'package:adv_11_am_firebase_app/views/screens/detail_page.dart';
import 'package:adv_11_am_firebase_app/views/screens/login_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/screens/home_page.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("===========BACKGROUND===========");
  await Firebase.initializeApp();
  print(message.notification!.title);
  print(message.notification!.body);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FCMPushNotificationHelper.fcmPushNotificationHelper.getFCMToken();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
    print("ForeGround");
    print(msg.notification!.title!);
    print(msg.notification!.body!);

    LocalNotificationHelper.localNotificationHelper.sendSimpleNotification(
        title: msg.notification!.title!, body: msg.notification!.body!);
  });

  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: 'login_page',
      routes: {
        '/': (context) => HomePage(),
        'login_page': (context) => LoginPage(),
        'detail_page': (context) => DetailPage(),
      },
    ),
  );
}
