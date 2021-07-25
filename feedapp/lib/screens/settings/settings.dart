import 'package:easy_localization/easy_localization.dart';
import 'package:feedapp/components/auth/views/AuthView.dart';
import 'package:feedapp/components/settings/AboutDialog.dart';
import 'package:feedapp/components/settings/SettingsTile.dart';
import 'package:feedapp/logic/blocs/authBloc/auth.dart';
import 'package:feedapp/utils/services/app/navigationService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feedapp/components/common/tilesHeader.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:feedapp/components/settings/buildHelpers/index.dart';
import 'package:feedapp/utils/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'widgets/singleSetting.dart';

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

  Widget _buildGeneralSection() {
    final auth = context.watch<AuthBloc>();
    if (auth.state is AuthorizedState) {
      return Column(
        children: [
          Divider(),
          SettingsTile(
            onTap: () {
              NavigationService.push(
                SingleSetting(
                  title: tr("settings.notification_preferences"),
                  child: buildNotificationPanel(context),
                ),
                RouteNames.SINGLE_SETTING,
              );
            },
            title: tr("settings.notification_preferences"),
            icon: Icons.circle_notifications_sharp,
            trailing: Icon(
              Icons.arrow_right_outlined,
              size: 32,
            ),
          ),
          Divider(),
          SettingsTile(
            onTap: () {
              AuthBloc.instance.add(AppLogout());
            },
            title: tr("settings.logout"),
            icon: Icons.logout_sharp,
          ),
        ],
      );
    }
    return Column(
      children: [
        Divider(),
        SettingsTile(
          onTap: () {
            NavigationService.push(AuthView(isLogin: true), RouteNames.AUTH);
          },
          title: tr("settings.login"),
          icon: Icons.account_circle,
        ),
        Divider(),
        SettingsTile(
          onTap: () {
            NavigationService.push(AuthView(isLogin: false), RouteNames.AUTH);
          },
          title: tr("settings.register"),
          icon: Icons.app_registration,
        ),
      ],
    );
  }

  @override
  Widget build(ctx) {
    final theme = Theme.of(ctx);
    return SingleChildScrollView(
      child: ListTileTheme(
        tileColor: theme.cardColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Container(
                child: Center(
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (ctx, state) {
                      if (state is AuthorizedState) {
                        final user = state.user;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: theme.primaryColor, width: 3),
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.transparent, width: 3),
                                  borderRadius: BorderRadius.circular(55.0),
                                ),
                                child: CircleAvatar(
                                  child: Text(
                                    user.firstName![0],
                                    style: TextStyle(fontSize: 50),
                                  ),
                                  radius: 50.0,
                                ),
                              ),
                            ),
                            Text(
                              '${user.firstName!} ${user.lastName!}',
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
              TilesHeader(
                title: tr("settings.general"),
              ),
              SettingsTile(
                onTap: () {
                  NavigationService.push(
                    SingleSetting(
                      title: tr("settings.language"),
                      child: LanguagePanel(),
                    ),
                    RouteNames.SINGLE_SETTING,
                  );
                },
                title: tr("settings.language"),
                icon: Icons.language,
                trailing: Icon(
                  Icons.arrow_right_outlined,
                  size: 32,
                ),
              ),
              _buildGeneralSection(),
              TilesHeader(
                title: tr("settings.about"),
              ),
              SettingsTile(
                onTap: () {
                  showAbout(ctx);
                },
                title: tr("settings.about"),
                icon: Icons.info,
              ),
              Divider(),
              SettingsTile(
                onTap: () {
                  // TODO redirect to web page
                },
                title: tr("settings.privacy"),
                icon: Icons.privacy_tip,
              ),
              Divider(),
              SettingsTile(
                onTap: () {
                  // TODO redirect to web page
                },
                title: tr("settings.terms"),
                icon: Icons.description,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
