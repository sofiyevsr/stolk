import 'package:flutter/material.dart';

typedef OnPressed = void Function();

class SingleLoginButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final Color color;
  final bool? disabled;
  final OnPressed onPressed;
  const SingleLoginButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.disabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 55,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(this.color),
          shadowColor: MaterialStateProperty.all(
            Colors.grey,
          ),
          textStyle: MaterialStateProperty.all(
            TextStyle(color: Colors.white),
          ),
        ),
        onPressed: disabled == true ? null : onPressed,
        icon: this.icon,
        label: Text(
          this.text,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
