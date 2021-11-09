import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/screens/auth/auth.dart';
import 'package:stolk/screens/settings/notification/NotificationPreferences.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';

import 'SettingsTile.dart';
import 'SingleSettings.dart';

class SettingsGeneralSection extends StatelessWidget {
  const SettingsGeneralSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (ctx, state) {
      if (state is AuthorizedState) {
        return Column(
          children: [
            SettingsTile(
              onTap: () {
                NavigationService.push(
                  SingleSettings(
                    title: ("settings.notification_preferences"),
                    child: NotificationPreferences(),
                  ),
                  RouteNames.SINGLE_SETTING,
                );
              },
              title: tr("settings.notification_preferences"),
              icon: Icons.circle_notifications_sharp,
              trailing: Icon(
                Icons.arrow_right_outlined,
              ),
            ),
            SettingsTile(
              onTap: state.isLoggingOut
                  ? null
                  : () {
                      AuthBloc.instance.add(
                        AppLogout(),
                      );
                    },
              isLoading: state.isLoggingOut,
              title: tr("settings.logout"),
              icon: Icons.logout_outlined,
            ),
          ],
        );
      }
      return Column(
        children: [
          SettingsTile(
            onTap: () {
              NavigationService.push(AuthPage(), RouteNames.AUTH);
            },
            title: tr("settings.login"),
            icon: Icons.account_circle_outlined,
          ),
        ],
      );
    });
  }
}
