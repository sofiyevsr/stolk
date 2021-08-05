import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NotificationPreferences extends StatelessWidget {
  const NotificationPreferences({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile.adaptive(
          title: Text(
            tr("settings.notifications.news"),
            style: Theme.of(context).textTheme.headline6,
          ),
          value: false,
          onChanged: (_) {},
        ),
        Divider(),
      ],
    );
  }
}
