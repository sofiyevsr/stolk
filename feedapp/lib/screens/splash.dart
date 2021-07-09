import "package:flutter/material.dart";

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: theme.primaryColor,
          strokeWidth: 10.0,
        ),
      ),
    );
  }
}
