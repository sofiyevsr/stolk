import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/components/auth/loginButtons.dart';
import 'package:stolk/components/common/typewriterText.dart';
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/logo.png",
                height: 150,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: TypewriterText(
                  text: "Stolk",
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: AutoSizeText(
                  tr("login.description"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
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
                    const EdgeInsets.only(bottom: 12.0),
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
