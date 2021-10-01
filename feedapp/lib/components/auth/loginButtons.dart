import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/components/auth/singleLoginButton.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/screens/auth/localAuth.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/oauth/google.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import 'package:stolk/utils/services/app/toastService.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons({Key? key}) : super(key: key);

  void _googleSignin() async {
    try {
      // Sign out required to give option to user to choose other account
      await signInGoogle.signOut();
      final data = await signInGoogle.signIn();
      final headers = await data?.authentication;
      if (headers?.idToken == null) throw Error();
      AuthBloc.instance.add(GoogleLogin(idToken: (headers!.idToken)!));
    } catch (e) {
      // Add Message that request failed
      ToastService.instance.showAlert(tr("errors.default"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        final buttonsDisabled = state is AuthLoadingState;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                onPressed: _googleSignin,
              ),
            SingleLoginButton(
              text: tr("login.email_sign_in"),
              icon: Icon(Icons.alternate_email, size: 30),
              color: Colors.blue[700]!,
              disabled: buttonsDisabled,
              onPressed: () {
                NavigationService.push(LocalAuthPage(), RouteNames.LOCAL_AUTH);
              },
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  tr("login.agree"),
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
