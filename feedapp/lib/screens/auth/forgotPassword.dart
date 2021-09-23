import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/components/common/buttonWithLoader.dart';
import 'package:stolk/components/common/inputs/email.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import 'package:stolk/utils/services/server/authService.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final controller = TextEditingController();
  final api = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              margin: const EdgeInsets.all(20),
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
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
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        tr("forgot_password.description"),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              color: Colors.grey[300],
                            ),
                      ),
                      // TODO implement different email input as validation doesn't work in this case
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: EmailInput(controller: controller),
                      ),
                      ButtonWithLoader(
                        isLoading: false,
                        onPressed: () {
                          // api.forgotPassword(email)
                        },
                        text: tr("forgot_password.submit"),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      NavigationService.pop();
                    },
                    child: Text(
                      tr("buttons.back_to_login"),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
