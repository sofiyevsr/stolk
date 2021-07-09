import "package:flutter/material.dart";

class IconBackground extends StatelessWidget {
  final color;
  final icon;
  final iconSize;
  final iconColor;
  const IconBackground({
    Key? key,
    Color? this.iconColor,
    Color? this.color,
    double this.iconSize = 30,
    required IconData this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.grey[700]
            : this.color ?? theme.accentColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Icon(
        this.icon,
        size: this.iconSize,
        color: iconColor,
      ),
    );
  }
}
