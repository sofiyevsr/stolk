import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/components/auth/loginButtons.dart';
import 'package:stolk/screens/auth/auth.dart';
import 'package:stolk/screens/home.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';

class IntroLogin extends StatelessWidget {
  const IntroLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/static/news-bg.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black,
                ],
                stops: [0.25, 1],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(
                      "assets/icons/logo.png",
                    ),
                  ),
                  Expanded(
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          "Stolk",
                          speed: const Duration(milliseconds: 350),
                          cursor: "|",
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 44,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                tr("login.description"),
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              LoginButtons(onLocalAuthPress: () {
                NavigationService.replaceAll(
                  const Home(),
                  RouteNames.HOME,
                  disableAnimation: true,
                );
                NavigationService.push(const AuthPage(), RouteNames.AUTH);
              }),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.all(0),
                  ),
                ),
                onPressed: () {
                  NavigationService.replaceAll(const Home(), RouteNames.HOME);
                },
                child: Text(
                  tr("commons.skip"),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
