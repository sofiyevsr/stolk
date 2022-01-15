import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/screens/settings/widgets/GeneralSection.dart';
import 'package:stolk/screens/settings/widgets/HeaderSection.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import "package:flutter/material.dart";
import 'package:stolk/utils/constants.dart';
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
  @override
  Widget build(ctx) {
    EasyLocalization.of(ctx);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
        ),
        child: Column(
          children: [
            SettingsHeaderSection(),
            SettingsTile(
              onTap: () {
                NavigationService.push(
                  const SingleSettings(
                    title: ("settings.language"),
                    child: LanguageSelector(),
                  ),
                  RouteNames.SINGLE_SETTING,
                );
              },
              title: tr("settings.language"),
              icon: Icons.translate_sharp,
            ),
            SettingsTile(
              onTap: () {
                NavigationService.push(
                  const SingleSettings(
                    title: ("settings.theme"),
                    child: ThemeSelector(),
                  ),
                  RouteNames.SINGLE_SETTING,
                );
              },
              icon: Icons.layers_outlined,
              title: tr("settings.theme"),
            ),
            SettingsGeneralSection(),
          ],
        ),
      ),
    );
  }
}
