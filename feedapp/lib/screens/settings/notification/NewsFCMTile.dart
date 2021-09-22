import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/server/notificationService.dart';

class FCMNewsNotificationTile extends StatefulWidget {
  FCMNewsNotificationTile({Key? key}) : super(key: key);

  @override
  _FCMNewsNotificationTile createState() => _FCMNewsNotificationTile();
}

class _FCMNewsNotificationTile extends State<FCMNewsNotificationTile> {
  final notificationService = NotificationService();
  bool isLoading = true;
  bool tileValue = false;

  @override
  void initState() {
    super.initState();
    (() async {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      final value = await notificationService.getFCMPreferences(token);
      for (int i = 0; i < value.topics.length; i++) {
        final element = value.topics[i];
        if (element.name == fcmNotificationChannels["news"]) {
          setState(() {
            tileValue = true;
            isLoading = false;
          });
          return;
        }
      }
      setState(() {
        isLoading = false;
      });
    })()
        .catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      title: Text(
        tr("settings.notifications.fcm_news"),
        style: Theme.of(context).textTheme.headline6,
      ),
      value: tileValue,
      onChanged: isLoading == true
          ? null
          : (value) async {
              setState(() {
                isLoading = true;
              });
              Future<void> request;
              if (value == true)
                request = FirebaseMessaging.instance
                    .subscribeToTopic(fcmNotificationChannels["news"]!);
              else
                request = FirebaseMessaging.instance
                    .unsubscribeFromTopic(fcmNotificationChannels["news"]!);

              request.then((_) {
                setState(() {
                  isLoading = false;
                  tileValue = value;
                });
              }).catchError((_) {
                setState(() {
                  isLoading = false;
                });
              });
            },
    );
  }
}
