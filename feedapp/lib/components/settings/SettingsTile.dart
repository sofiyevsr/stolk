import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final void Function()? onTap;

  SettingsTile(
      {required this.title, required this.icon, this.onTap, this.trailing});

  @override
  Widget build(context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        this.icon,
        size: 34,
      ),
      title: Text(
        title,
      ),
      trailing: trailing,
    );
  }
}
