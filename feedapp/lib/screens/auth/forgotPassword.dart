import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/components/common/buttonWithLoader.dart';
import 'package:stolk/components/common/inputs/email.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import 'package:stolk/utils/services/app/toastService.dart';
import 'package:stolk/utils/services/server/authService.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final api = AuthService();
  bool _isLoading = false;
  bool _isDone = false;
  String? email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Container(
                margin: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset("assets/static/forgot-password.png",
                            height: 250),
                        Text(
                          tr("forgot_password.title"),
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          tr("forgot_password.description"),
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.subtitle1?.copyWith(
                                    color: Colors.grey[300],
                                  ),
                        ),
                        if (_isDone == false)
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  child: EmailInput(
                                    onSaved: (v) {
                                      email = v;
                                    },
                                  ),
                                ),
                                ButtonWithLoader(
                                  isLoading: _isLoading,
                                  onPressed: () async {
                                    if (_formKey.currentState == null ||
                                        !_formKey.currentState!.validate())
                                      return;
                                    _formKey.currentState!.save();
                                    if (email != null) {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      api.forgotPassword(email!).then((value) {
                                        setState(() {
                                          _isDone = true;
                                        });
                                      }).catchError((_) {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                                  text: tr("forgot_password.submit"),
                                ),
                              ],
                            ),
                          ),
                        if (_isDone == true)
                          Container(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 100,
                                  color: Colors.green,
                                ),
                                Text(
                                  tr("forgot_password.success"),
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () {
                        NavigationService.pop();
                      },
                      child: Text(
                        tr("buttons.back_to_login"),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
