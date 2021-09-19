import 'package:flutter/material.dart';

typedef OnPressed = void Function();

class SingleLoginButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final Color color;
  final OnPressed onPressed;
  const SingleLoginButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 55,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue[700]),
          shadowColor: MaterialStateProperty.all(
            Colors.grey,
          ),
        ),
        onPressed: onPressed,
        icon: Icon(Icons.login),
        label: Text(
          "Local login",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
