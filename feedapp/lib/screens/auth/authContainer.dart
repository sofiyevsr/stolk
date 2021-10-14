import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/components/auth/loginButtons.dart';

class AuthContainer extends StatelessWidget {
  final bool? disableMinConstraint;
  const AuthContainer({Key? key, this.disableMinConstraint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: Theme.of(context).cardColor,
        constraints: BoxConstraints(
          maxHeight: constraints.maxHeight,
        ),
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: this.disableMinConstraint == true
                  ? 0.0
                  : constraints.maxHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        tr("login.title"),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        tr("login.description"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                      ),
                    ),
                    LoginButtons(),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    tr("login.agree"),
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
