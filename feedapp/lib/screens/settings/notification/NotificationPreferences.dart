import 'package:flutter/material.dart';
import 'package:stolk/components/common/centerLoadingWidget.dart';
import 'package:stolk/components/error/fetchFailWidget.dart';
import 'package:stolk/utils/@types/response/index.dart';
import 'package:stolk/utils/services/server/notificationService.dart';

import 'NotificationPreferenceTile.dart';

class NotificationPreferences extends StatefulWidget {
  const NotificationPreferences({Key? key}) : super(key: key);

  @override
  State<NotificationPreferences> createState() =>
      _NotificationPreferencesState();
}

class _NotificationPreferencesState extends State<NotificationPreferences> {
  final notificationService = NotificationService();
  List<SingleLocalNotification>? preferences;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    notificationService.getMyNotificationPreferences().then((value) {
      if (mounted)
        setState(() {
          preferences = value.preferences;
          isLoading = false;
        });
    }).catchError((e) {
      if (mounted)
        setState(() {
          isLoading = false;
          hasError = true;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) return CenterLoadingWidget();
    if (hasError == true || preferences == null) return FetchFailWidget();
    return Column(
      children: preferences!
          .map(
            (e) => NotificationPreferenceTile(
              name: e.name,
              typeID: e.id,
              createdAt: e.createdAt,
            ),
          )
          .toList(),
    );
  }
}
