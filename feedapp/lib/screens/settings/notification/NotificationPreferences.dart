import 'package:flutter/material.dart';

import 'NewsAppTile.dart';
import 'NewsFCMTile.dart';

class NotificationPreferences extends StatelessWidget {
  const NotificationPreferences({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppNewsNotificationTile(),
        Divider(),
        FCMNewsNotificationTile(),
        Divider(),
      ],
    );
  }
}
