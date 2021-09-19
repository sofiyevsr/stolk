import 'package:flutter/material.dart';
import 'package:stolk/utils/services/app/navigationService.dart';

import '../loginButtons.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
              child: Container(
                color: Theme.of(context).cardColor,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Sign in",
                          style: Theme.of(context).textTheme.headline3),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 70.0),
                      child: Text(
                        "Please log in using one of options below for better and personalized experience",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: LoginButtons(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
