import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/server/notificationService.dart';

class AppNewsNotificationTile extends StatefulWidget {
  AppNewsNotificationTile({Key? key}) : super(key: key);

  @override
  _AppNewsNotificationTile createState() => _AppNewsNotificationTile();
}

// This class is responsible only for sourcefollow
class _AppNewsNotificationTile extends State<AppNewsNotificationTile> {
  final notificationService = NotificationService();
  bool isLoading = true;
  bool tileValue = true;

  @override
  void initState() {
    super.initState();
    notificationService.getMyNotificationPreferences().then((value) {
      // if optout created_at is not null this means user hasn't opted out
      for (int i = 0; i < value.preferences.length; i++) {
        final element = value.preferences[i];
        if (element.id == NotificationOptoutType.SourceFollow) {
          // user hasn't opted out
          if (element.createdAt == null) {
            setState(() {
              tileValue = true;
              isLoading = false;
            });
          } else
            setState(() {
              tileValue = false;
              isLoading = false;
            });
          return;
        }
      }
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      title: Text(
        tr("settings.notifications.app_news"),
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
                request = notificationService
                    .optin(NotificationOptoutType.SourceFollow);
              else
                request = notificationService
                    .optout(NotificationOptoutType.SourceFollow);

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
