import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/components/common/buttonWithLoader.dart';
import 'package:stolk/components/common/inputs/email.dart';
import 'package:stolk/components/common/inputs/password.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/screens/auth/forgotPassword.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';

class LoginSection extends StatefulWidget {
  @override
  _LoginSectionState createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  String? _email, _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(ctx) {
    final authBloc = ctx.watch<AuthBloc>();
    final isLoading = authBloc.state is AuthLoadingState;
    return Align(
      alignment: Alignment.center,
      child: FocusScope(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EmailInput(
                onSaved: (s) {
                  _email = s;
                },
              ),
              PasswordInput(
                onSaved: (s) {
                  _password = s;
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    NavigationService.push(
                      ForgotPasswordPage(),
                      RouteNames.FORGOT_PASSWORD,
                    );
                  },
                  child: Text("forgot_password"),
                ),
              ),
              ButtonWithLoader(
                isLoading: isLoading,
                text: tr('login.login_button_label'),
                onPressed: () {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ctx
                        .read<AuthBloc>()
                        .add(AppLogin(email: _email!, password: _password!));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
