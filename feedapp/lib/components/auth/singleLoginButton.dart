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
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 55,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(this.color),
          shadowColor: MaterialStateProperty.all(
            Colors.grey,
          ),
          textStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white),
          ),
        ),
        onPressed: disabled == true ? null : onPressed,
        icon: icon,
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class RoundedSingleLoginButton extends StatelessWidget {
  final Widget icon;
  final Color color;
  final bool? disabled;
  final OnPressed onPressed;
  const RoundedSingleLoginButton({
    Key? key,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.disabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        iconSize: 48,
        onPressed: disabled == true ? null : onPressed,
        icon: icon,
      ),
    );
  }
}
