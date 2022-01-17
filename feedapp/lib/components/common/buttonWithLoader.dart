import 'package:auto_size_text/auto_size_text.dart';
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
        child: Container(
          height: 25,
          alignment: Alignment.center,
          child: isLoading == true
              ? SizedBox.fromSize(
                  size: const Size(25, 25),
                  child: const CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                  ),
                )
              : AutoSizeText(
                  text,
                  maxLines: 1,
                ),
        ),
        onPressed: isLoading == true ? null : this.onPressed,
      ),
    );
  }
}
