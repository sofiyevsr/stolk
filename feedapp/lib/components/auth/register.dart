import 'package:easy_localization/easy_localization.dart';
import 'package:feedapp/components/common/buttonWithLoader.dart';
import 'package:feedapp/components/common/inputs/email.dart';
import 'package:feedapp/components/common/inputs/lastName.dart';
import 'package:feedapp/components/common/inputs/firstName.dart';
import 'package:feedapp/components/common/inputs/password.dart';
import 'package:feedapp/logic/blocs/authBloc/auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? _email, _password, _firstName, _lastName;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(ctx) {
    final auth = ctx.watch<AuthBloc>();
    final isLoading = auth.state is AuthLoadingState;
    return Align(
      alignment: Alignment.center,
      child: FocusScope(
        child: Form(
          autovalidateMode: AutovalidateMode.disabled,
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EmailInput(
                onSaved: (s) {
                  _email = s;
                },
              ),
              FirstNameInput(
                onSaved: (s) {
                  _firstName = s;
                },
              ),
              LastNameInput(
                onSaved: (s) {
                  _lastName = s;
                },
              ),
              PasswordInput(
                onSaved: (s) {
                  _password = s;
                },
              ),
              ButtonWithLoader(
                isLoading: isLoading,
                onPressed: () {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ctx.read<AuthBloc>().add(
                          AppRegister(
                            firstName: _firstName!,
                            lastName: _lastName!,
                            email: _email!,
                            password: _password!,
                          ),
                        );
                  }
                },
                text: tr('register.register_button_label'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
