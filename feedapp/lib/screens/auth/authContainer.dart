import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/components/auth/loginButtons.dart';
import 'package:stolk/utils/constants.dart';

class AuthContainer extends StatelessWidget {
  // Required for showing container
  // inside bottom sheet
  final bool? bottomSheet;
  const AuthContainer({Key? key, this.bottomSheet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: constraints.maxHeight,
        ),
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: bottomSheet == true ? 0.0 : constraints.maxHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        tr("login.title"),
                        style: theme.textTheme.headline3,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        tr("login.description"),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyText1,
                      ),
                    ),
                    const LoginButtons(),
                  ],
                ),
                Container(
                  key: const ValueKey("agree"),
                  margin: const EdgeInsets.all(
                    8,
                  ),
                  child: Text(
                    tr("login.agree"),
                    style: theme.textTheme.bodyText2,
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
