import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/components/auth/singleLoginButton.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/utils/oauth/index.dart';

class RoundedLoginButtons extends StatelessWidget {
  final void Function()? onLocalAuthPress;
  const RoundedLoginButtons({Key? key, this.onLocalAuthPress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        final buttonsDisabled = state is AuthLoadingState;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RoundedSingleLoginButton(
              key: const ValueKey("facebook"),
              icon: Image.asset(
                "assets/icons/facebook.png",
                width: 30,
                height: 30,
              ),
              color: const Color.fromRGBO(66, 103, 178, 1),
              disabled: buttonsDisabled,
              onPressed: facebookSignIn,
            ),
            if (Platform.isIOS)
              RoundedSingleLoginButton(
                key: const ValueKey("apple"),
                icon: Image.asset(
                  "assets/icons/apple.png",
                  width: 30,
                  height: 30,
                ),
                color: Colors.black,
                disabled: buttonsDisabled,
                onPressed: () {},
              ),
            RoundedSingleLoginButton(
              key: const ValueKey("google"),
              icon: Image.asset(
                "assets/icons/google.png",
                width: 30,
                height: 30,
              ),
              color: Colors.red[700]!,
              disabled: buttonsDisabled,
              onPressed: googleSignin,
            ),
          ],
        );
      }),
    );
  }
}
