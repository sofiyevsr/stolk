import 'package:flutter/material.dart';
import 'package:stolk/screens/auth/authContainer.dart';
import 'package:stolk/utils/services/app/navigationService.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Stack(
            children: [
              Image.asset("assets/static/satellite.jpg"),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Icon(
                  Icons.arrow_back_sharp,
                  size: 30,
                ),
                onPressed: () {
                  NavigationService.pop();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: AuthContainer(),
        ),
      ],
    );
  }
}
