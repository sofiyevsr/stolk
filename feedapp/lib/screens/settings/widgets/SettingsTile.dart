import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final EdgeInsets? padding;
  final void Function()? onTap;

  SettingsTile({
    required this.title,
    required this.icon,
    this.padding,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Icon(
            this.icon,
            size: 32,
          ),
          contentPadding: padding,
          title: Text(
            title,
          ),
          trailing: trailing,
        ),
        Divider(),
      ],
    );
  }
}
