import 'package:flutter/material.dart';
import 'package:stolk/screens/auth/authContainer.dart';
import 'package:stolk/utils/services/app/navigationService.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Image.asset("assets/static/satellite.jpg"),
            IconButton(
              icon: const Icon(
                Icons.arrow_back_sharp,
                size: 30,
              ),
              onPressed: () {
                NavigationService.pop();
              },
            ),
          ],
        ),
        const Expanded(
          child: AuthContainer(),
        ),
      ],
    );
  }
}
