import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMPushNotificationHelper {
  FCMPushNotificationHelper._();
  static final FCMPushNotificationHelper fcmPushNotificationHelper =
      FCMPushNotificationHelper._();

  Future<void> getFCMToken() async {
    await Firebase.initializeApp();
    String? token = await FirebaseMessaging.instance.getToken();

    print("===================================");
    print(token);
    print("===================================");
  }
}
