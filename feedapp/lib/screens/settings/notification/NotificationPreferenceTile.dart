import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/utils/services/server/notificationService.dart';

class NotificationPreferenceTile extends StatefulWidget {
  final int typeID;
  final String? createdAt;
  final String name;
  const NotificationPreferenceTile({
    Key? key,
    required this.typeID,
    required this.name,
    required this.createdAt,
  }) : super(key: key);

  @override
  _NotificationPreferenceTile createState() => _NotificationPreferenceTile();
}

class _NotificationPreferenceTile extends State<NotificationPreferenceTile> {
  final notificationService = NotificationService();
  late bool tileValue = widget.createdAt == null;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      title: Text(
        tr("settings.notifications.${widget.name}"),
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
                request = notificationService.optin(widget.typeID);
              else
                request = notificationService.optout(widget.typeID);

              request.then((_) {
                if (mounted)
                  setState(() {
                    isLoading = false;
                    tileValue = value;
                  });
              }).catchError((_) {
                if (mounted)
                  setState(() {
                    isLoading = false;
                  });
              });
            },
    );
  }
}
