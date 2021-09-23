import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/components/common/buttonWithLoader.dart';
import 'package:stolk/components/common/inputs/email.dart';
import 'package:stolk/components/common/inputs/lastName.dart';
import 'package:stolk/components/common/inputs/firstName.dart';
import 'package:stolk/components/common/inputs/password.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterSection extends StatefulWidget {
  @override
  _RegisterSectionState createState() => _RegisterSectionState();
}

class _RegisterSectionState extends State<RegisterSection> {
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  tr("register.agree"),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.start,
                ),
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
