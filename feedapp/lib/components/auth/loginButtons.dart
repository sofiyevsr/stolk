import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/components/auth/singleLoginButton.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/screens/auth/auth.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/oauth/index.dart';
import 'package:stolk/utils/services/app/navigationService.dart';

class LoginButtons extends StatelessWidget {
  final void Function()? onLocalAuthPress;
  const LoginButtons({Key? key, this.onLocalAuthPress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        final buttonsDisabled = state is AuthLoadingState;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleLoginButton(
              text: tr("login.facebook_sign_in"),
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Image.asset(
                  "assets/icons/facebook.png",
                  width: 30,
                  height: 30,
                ),
              ),
              color: const Color.fromRGBO(66, 103, 178, 1),
              disabled: buttonsDisabled,
              onPressed: facebookSignIn,
            ),
            if (Platform.isIOS)
              SingleLoginButton(
                text: tr("login.apple_sign_in"),
                icon: Image.asset(
                  "assets/icons/apple.png",
                  width: 30,
                  height: 30,
                ),
                color: Colors.black,
                disabled: buttonsDisabled,
                onPressed: () {},
              ),
            if (Platform.isAndroid)
              SingleLoginButton(
                text: tr("login.google_sign_in"),
                icon: Image.asset(
                  "assets/icons/google.png",
                  width: 30,
                  height: 30,
                ),
                color: Colors.red[700]!,
                disabled: buttonsDisabled,
                onPressed: googleSignin,
              ),
            SingleLoginButton(
              text: tr("login.email_sign_in"),
              icon: const Icon(Icons.alternate_email, size: 30),
              color: CustomColorScheme.main,
              disabled: buttonsDisabled,
              onPressed: onLocalAuthPress != null
                  ? onLocalAuthPress!
                  : () {
                      NavigationService.push(const AuthPage(), RouteNames.AUTH);
                    },
            ),
          ],
        );
      }),
    );
  }
}
