import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/components/common/buttonWithLoader.dart';
import 'package:stolk/components/common/inputs/email.dart';
import 'package:stolk/components/common/lottieLoader.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
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
        child: SizedBox.expand(
          child: Stack(
            children: [
              if (_isDone == false)
                Center(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.all(30),
                      child: Column(
                        key: const ValueKey("form"),
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              tr("forgot_password.title"),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              tr("forgot_password.description"),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    color: Colors.grey[500],
                                  ),
                            ),
                          ),
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
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      });
                                    }
                                  },
                                  text: tr("forgot_password.submit"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (_isDone == true)
                Center(
                  child: Column(
                    key: const ValueKey("success"),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const LottieLoader(
                        asset: "assets/lottie/email_send.json",
                        size: Size(250, 250),
                        repeat: false,
                      ),
                      AutoSizeText(
                        tr("forgot_password.success"),
                        maxLines: 2,
                        minFontSize: 32,
                      ),
                    ],
                  ),
                ),
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_sharp,
                    size: 32,
                  ),
                  padding: const EdgeInsets.all(16),
                  onPressed: () {
                    NavigationService.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
