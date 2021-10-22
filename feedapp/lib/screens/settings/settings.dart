import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/screens/auth/auth.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/components/common/tilesHeader.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:stolk/utils/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stolk/utils/services/app/toastService.dart';
import 'package:url_launcher/url_launcher.dart';

import 'notification/NotificationPreferences.dart';
import 'widgets/AboutDialog.dart';
import 'widgets/LanguageSelector.dart';
import 'widgets/SettingsTile.dart';
import 'widgets/SingleSetting.dart';
import 'widgets/ThemeSelector.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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

  Widget buildHeaderSection() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (ctx, state) {
        if (state is AuthorizedState) {
          final user = state.user;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 3),
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent, width: 3),
                      borderRadius: BorderRadius.circular(55.0),
                    ),
                    child: CircleAvatar(
                      child: Text(
                        user.firstName[0],
                        style: TextStyle(fontSize: 50),
                      ),
                      radius: 50.0,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    if (user.confirmedAt != null)
                      Tooltip(
                        message: tr("tooltips.account_verified"),
                        child: Icon(Icons.verified, color: Colors.blue),
                      ),
                  ],
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget buildGeneralSection() {
    final auth = context.watch<AuthBloc>();
    if (auth.state is AuthorizedState) {
      return Column(
        children: [
          SettingsTile(
            onTap: () {
              NavigationService.push(
                SingleSetting(
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
            NavigationService.push(AuthPage(), RouteNames.AUTH);
          },
          title: tr("settings.login"),
          icon: Icons.account_circle_outlined,
        ),
      ],
    );
  }

  @override
  Widget build(ctx) {
    final theme = Theme.of(ctx);
    return SingleChildScrollView(
      child: ListTileTheme(
        dense: true,
        iconColor: theme.primaryColorLight,
        tileColor: theme.cardColor,
        minLeadingWidth: 0,
        child: Column(
          children: [
            buildHeaderSection(),
            TilesHeader(
              title: tr("settings.general"),
            ),
            SettingsTile(
              onTap: () {
                NavigationService.push(
                  SingleSetting(
                    title: ("settings.language"),
                    child: LanguagePanel(),
                  ),
                  RouteNames.SINGLE_SETTING,
                );
              },
              title: tr("settings.language"),
              icon: Icons.language,
              trailing: Icon(
                Icons.arrow_right_outlined,
              ),
            ),
            ThemeSelector(),
            buildGeneralSection(),
            TilesHeader(
              title: tr("settings.about"),
            ),
            SettingsTile(
              onTap: () => showAbout(ctx),
              title: tr("settings.about"),
              icon: Icons.info_outlined,
            ),
            SettingsTile(
              onTap: () => launchURL(privacyPolicyURL),
              title: tr("settings.privacy"),
              icon: Icons.privacy_tip_outlined,
            ),
            SettingsTile(
              onTap: () => launchURL(termsOfUseURL),
              title: tr("settings.terms"),
              icon: Icons.description_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
