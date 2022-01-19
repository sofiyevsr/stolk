import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/utils/services/app/toastService.dart';

GoogleSignIn _signInGoogle = GoogleSignIn(
  scopes: ['openid', 'profile', 'email'],
);

Future<void> facebookSignIn() async {
  try {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final AccessToken? accessToken = result.accessToken;
      if (accessToken == null) throw Error();
      AuthBloc.instance.add(
        FacebookLogin(token: accessToken.token),
      );
    } else {
      throw Error();
    }
  } catch (e) {
    ToastService.instance.showAlert(tr("errors.default"));
  }
}

Future<void> googleSignin() async {
  try {
    // Sign out required to give option to user to choose other account
    await _signInGoogle.signOut();
    final data = await _signInGoogle.signIn();
    final headers = await data?.authentication;
    if (headers?.idToken == null) throw Error();
    AuthBloc.instance.add(GoogleLogin(idToken: (headers!.idToken)!));
  } catch (e) {
    // Add Message that request failed
    ToastService.instance.showAlert(tr("errors.default"));
  }
}
