import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static final instance = LocalNotification._();
  final AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'fcm_channel', // id
    'FCM Channel', // title
    'Channel to use notifications of FCM', // description
    importance: Importance.max,
  );
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'fcm_channel', // id
      'FCM Channel', // title
      'Channel to use notifications of FCM', // description
    ),
  );

  LocalNotification._();

  Future<void> init() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await FlutterLocalNotificationsPlugin().initialize(
      initializationSettings,
    );
  }

  void show({required int id, required String title, required String body}) {
    _flutterLocalNotificationsPlugin.show(id, title, body, _details);
  }
}
