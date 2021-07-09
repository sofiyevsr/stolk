import 'package:flutter/material.dart';

class ButtonWithLoader extends StatelessWidget {
  final bool isLoading;
  final void Function() onPressed;
  final String text;
  const ButtonWithLoader({
    Key? key,
    required this.isLoading,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: SizedBox(
          height: 25,
          child: Center(
            child: isLoading == true
                ? SizedBox(
                    width: 25,
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Text(
                    this.text,
                  ),
          ),
        ),
        onPressed: isLoading == true ? null : this.onPressed,
      ),
    );
  }
}
