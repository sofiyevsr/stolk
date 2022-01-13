import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'SettingsTile.dart';

const themes = ["system", "dark", "light"];

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: Icons.layers_outlined,
      title: tr("settings.theme"),
      padding: const EdgeInsets.only(left: 16),
    );
  }
}
