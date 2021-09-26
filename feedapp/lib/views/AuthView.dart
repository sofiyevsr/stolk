import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/components/auth/loginButtons.dart';
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
          child: Container(
            color: Theme.of(context).cardColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(tr("login.title"),
                      style: Theme.of(context).textTheme.headline3),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 70.0),
                  child: Text(
                    tr("login.description"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[500],
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
    );
  }
}
