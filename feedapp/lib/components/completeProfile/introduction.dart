import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/components/common/lottieLoader.dart';

class CompleteProfileIntroduction extends StatelessWidget {
  final Function() nextPage;
  const CompleteProfileIntroduction({Key? key, required this.nextPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const LottieLoader(
            asset: "assets/lottie/rocket_launch.json",
            size: Size(330, 330),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              tr("intro.one_more_step"),
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              tr("intro.choose_sources"),
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
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
                child: AutoSizeText(
                  tr(
                    "intro.get_started",
                  ),
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
