import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationHelper {
  LocalNotificationHelper._();

  static final LocalNotificationHelper localNotificationHelper =
      LocalNotificationHelper._();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initNotifications() {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings("ic_launcher");
    DarwinInitializationSettings darwinInitializationSettings =
        const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );

    tz.initializeTimeZones();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) {
      debugPrint("================================================");
      debugPrint(response.payload);
      debugPrint("================================================");
    });
  }

  Future<void> sendSimpleNotification(
      {required String title, required String body}) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "101",
      "Flutter",
      priority: Priority.high,
      importance: Importance.max,
    );
    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      101,
      title,
      body,
      notificationDetails,
      payload: "Simple Notification Clicked",
    );
  }

  sendScheduledNotification() {
    tz.initializeTimeZones();

    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "101",
      "Flutter Schedule",
      priority: Priority.high,
      importance: Importance.max,
    );

    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    flutterLocalNotificationsPlugin.zonedSchedule(
      105,
      "Scheduled title",
      "Scheduled body",
      tz.TZDateTime(tz.local, 2023, 3, 24, 12),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  sendBigPictureNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "101",
      "Flutter",
      priority: Priority.high,
      importance: Importance.max,
      styleInformation: BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("ic_launcher"),
      ),
      largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
    );
    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      101,
      "Simple Notification",
      "This is demo notification.",
      notificationDetails,
      payload: "Simple Notification Clicked",
    );
  }

  sendMediaStyleNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "101",
      "Flutter",
      priority: Priority.high,
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound("notification"),
    );
    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      101,
      "MediaStyle Notification",
      "This is MediaStyle notification.",
      notificationDetails,
      payload: "MediaStyle Notification Clicked",
    );
  }
}
