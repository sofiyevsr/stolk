import 'package:easy_localization/easy_localization.dart';
import 'package:feedapp/components/common/buttonWithLoader.dart';
import 'package:feedapp/components/common/inputs/email.dart';
import 'package:feedapp/components/common/inputs/password.dart';
import 'package:feedapp/logic/blocs/authBloc/auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
