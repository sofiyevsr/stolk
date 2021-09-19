import 'package:flutter/material.dart';
import 'package:stolk/utils/oauth/google.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons({Key? key}) : super(key: key);

  void _googleSignin() async {
    await signInGoogle.signOut();
    final data = await signInGoogle.signIn();
    final headers = await data?.authentication;
    await data?.clearAuthCache();
    print(headers?.idToken);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 55,
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                shadowColor: MaterialStateProperty.all(
                  Colors.grey,
                ),
              ),
              onPressed: () {},
              icon: Image.asset(
                "assets/icons/apple.png",
                width: 30,
                height: 30,
              ),
              label: Text(
                "Apple login",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 55,
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red[700]),
                shadowColor: MaterialStateProperty.all(
                  Colors.grey,
                ),
              ),
              onPressed: _googleSignin,
              icon: Image.asset(
                "assets/icons/google.png",
                width: 30,
                height: 30,
              ),
              label: Text(
                "Google login",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 55,
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue[700]),
                shadowColor: MaterialStateProperty.all(
                  Colors.grey,
                ),
              ),
              onPressed: () {},
              icon: Icon(Icons.login),
              label: Text(
                "Local login",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text("agree"),
            ),
          ),
        ],
      ),
    );
  }
}
