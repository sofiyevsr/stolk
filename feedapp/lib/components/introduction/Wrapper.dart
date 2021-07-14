import 'package:feedapp/screens/home.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:feedapp/logic/hive/settings.dart';
import 'package:feedapp/screens/intro.dart';
import "package:flutter/material.dart";

class IntroductionWrapper extends StatelessWidget {
  const IntroductionWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Settings>("settings").listenable(),
      builder: (ctx, Box<Settings> gBox, _) {
        final box = gBox.get("main", defaultValue: Settings())!;
        if (box.skipIntro == true)
          return Home();
        else
          return IntroScreen();
      },
    );
  }
}
