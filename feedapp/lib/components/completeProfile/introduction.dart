import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CompleteProfileIntroduction extends StatelessWidget {
  final Function() nextPage;
  const CompleteProfileIntroduction({Key? key, required this.nextPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          tr("introduction.one_more_step"),
          style: Theme.of(context).textTheme.headline4,
          textAlign: TextAlign.center,
        ),
        Flexible(
          flex: 3,
          child: Lottie.asset(
            "assets/lottie/confetti.json",
          ),
        ),
        Text(
          tr("introduction.choose_sources"),
          style: Theme.of(context).textTheme.headline6,
        ),
        Flexible(
          flex: 1,
          child: Center(
            child: ElevatedButton(
              onPressed: nextPage,
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.all(18),
                ),
              ),
              child: Text(
                tr(
                  "introduction.get_started",
                ),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
