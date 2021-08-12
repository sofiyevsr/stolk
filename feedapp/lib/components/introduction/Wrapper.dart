import 'package:stolk/screens/home.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stolk/screens/intro.dart';
import "package:flutter/material.dart";

class IntroductionWrapper extends StatelessWidget {
  const IntroductionWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box("settings").listenable(keys: ["skipIntro"]),
      builder: (ctx, Box gBox, _) {
        final skipIntro = gBox.get("skipIntro", defaultValue: false);
        if (skipIntro == true)
          return Home();
        else
          return IntroScreen();
      },
    );
  }
}
