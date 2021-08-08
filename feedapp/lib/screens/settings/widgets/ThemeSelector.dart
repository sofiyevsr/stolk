import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'SettingsTile.dart';

const themes = ["system", "dark", "light"];

class ThemeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: Icons.layers_outlined,
      title: tr("settings.theme"),
      padding: const EdgeInsets.only(left: 16),
      trailing: ValueListenableBuilder(
          valueListenable: Hive.box('settings').listenable(keys: ["theme"]),
          builder: (context, Box gBox, widget) {
            final theme = gBox.get("theme", defaultValue: "system");
            return ToggleButtons(
              children: [
                Icon(Icons.phone_android),
                Icon(Icons.dark_mode),
                Icon(Icons.light_mode),
              ],
              isSelected: [
                theme == "system",
                theme == "dark",
                theme == "light"
              ],
              onPressed: (i) {
                gBox.put("theme", themes[i]);
              },
            );
          }),
    );
  }
}
