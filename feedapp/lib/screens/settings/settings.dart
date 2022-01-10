import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/screens/settings/widgets/GeneralSection.dart';
import 'package:stolk/screens/settings/widgets/HeaderSection.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import "package:flutter/material.dart";
import 'package:stolk/utils/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stolk/utils/services/app/toastService.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/AboutDialog.dart';
import 'widgets/LanguageSelector.dart';
import 'widgets/SettingsTile.dart';
import 'widgets/SingleSettings.dart';
import 'widgets/ThemeSelector.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
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

  @override
  Widget build(ctx) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SettingsHeaderSection(),
          SettingsTile(
            onTap: () {
              NavigationService.push(
                const SingleSettings(
                  title: ("settings.language"),
                  child: LanguagePanel(),
                ),
                RouteNames.SINGLE_SETTING,
              );
            },
            title: tr("settings.language"),
            icon: Icons.translate_sharp,
            trailing: const Icon(
              Icons.arrow_right_outlined,
            ),
          ),
          const ThemeSelector(),
          const SettingsGeneralSection(),
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
    );
  }
}
