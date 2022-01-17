import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'lottieLoader.dart';

class NoNewsWidget extends StatelessWidget {
  final bool followMore;
  final bool center;
  const NoNewsWidget({Key? key, required this.followMore, this.center = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: center == true ? Alignment.center : null,
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LottieLoader(
            asset: "assets/lottie/no_data.json",
            size: Size(250, 250),
            repeat: false,
          ),
          AutoSizeText(
            followMore ? tr("news.no_news_follow_more") : tr("news.no_news"),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
