import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/components/auth/loginButtons.dart';
import 'package:stolk/screens/auth/localAuth.dart';
import 'package:stolk/screens/home.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';

class IntroLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/static/news-bg.jpg",
            fit: BoxFit.cover,
            color: Colors.black38,
            colorBlendMode: BlendMode.darken,
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
                    child: Text(
                      "Stolk",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 44,
                      ),
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
                NavigationService.replaceAll(Home(), RouteNames.HOME);
                NavigationService.push(LocalAuthPage(), RouteNames.LOCAL_AUTH);
              }),
            ],
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: TextButton(
            onPressed: () {
              NavigationService.replaceAll(Home(), RouteNames.HOME);
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
        ),
      ],
    );
  }
}
