import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/screens/auth/auth.dart';
import 'package:stolk/screens/settings/notification/NotificationPreferences.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import 'package:stolk/utils/services/app/toastService.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AboutDialog.dart';
import 'SettingsTile.dart';
import 'SingleSettings.dart';

class SettingsGeneralSection extends StatelessWidget {
  SettingsGeneralSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (ctx, state) {
      if (state is AuthorizedState) {
        return Column(
          children: [
            SettingsTile(
              key: const ValueKey("notification_preferences"),
              onTap: () {
                NavigationService.push(
                  const SingleSettings(
                    title: ("settings.notification_preferences"),
                    child: NotificationPreferences(),
                  ),
                  RouteNames.SINGLE_SETTING,
                );
              },
              title: tr("settings.notification_preferences"),
              icon: Icons.notifications_outlined,
            ),
            _AboutSection(),
            SettingsTile(
              key: const ValueKey("logout"),
              onTap: () {
                AuthBloc.instance.add(
                  AppLogout(),
                );
              },
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
              NavigationService.push(const AuthPage(), RouteNames.AUTH);
            },
            title: tr("settings.login"),
            icon: Icons.account_circle_outlined,
          ),
          _AboutSection(),
        ],
      );
    });
  }
}

class _AboutSection extends StatelessWidget {
  _AboutSection({Key? key}) : super(key: key);

  void showAbout(BuildContext context) async {
    final details = await PackageInfo.fromPlatform();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: CustomAboutDialog(details: details),
      ),
    );
  }

  Future<void> launchURL(String url) async {
    try {
      await launch(url);
    } catch (e) {
      ToastService.instance.showAlert(
        tr("errors.cannot_launch_url"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsTile(
          key: ValueKey("about"),
          onTap: () => showAbout(context),
          title: tr("settings.about"),
          icon: Icons.info_outlined,
        ),
        SettingsTile(
          key: ValueKey("privacy"),
          onTap: () => launchURL(privacyPolicyURL),
          title: tr("settings.privacy"),
          icon: Icons.privacy_tip_outlined,
        ),
        SettingsTile(
          key: ValueKey("terms"),
          onTap: () => launchURL(termsOfUseURL),
          title: tr("settings.terms"),
          icon: Icons.description_outlined,
        ),
      ],
    );
  }
}
