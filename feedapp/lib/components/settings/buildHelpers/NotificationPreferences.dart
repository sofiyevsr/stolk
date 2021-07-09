part of "./index.dart";

Widget buildNotificationPanel(
  BuildContext context,
) =>
    Column(
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
