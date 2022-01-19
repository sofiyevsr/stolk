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
          backgroundColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.disabled))
              return color.withAlpha(200);
            return color;
          }),
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
    return ElevatedButton(
      onPressed: disabled == true ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.disabled))
            return color.withAlpha(200);
          return color;
        }),
        shape: MaterialStateProperty.all(const CircleBorder()),
        minimumSize: MaterialStateProperty.all(Size.zero),
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(12),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 4,
        ),
        child: icon,
      ),
    );
  }
}
