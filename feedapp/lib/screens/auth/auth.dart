import 'package:flutter/material.dart';
import 'package:stolk/views/AuthView.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: AuthView(),
      ),
    );
  }
}
