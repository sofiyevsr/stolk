import "package:flutter/material.dart";

class FetchFailScreen extends StatelessWidget {
  final String text;
  FetchFailScreen({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 64,
              ),
              Text(text)
            ],
          ),
        ),
      ),
    );
  }
}
