import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NoNewsWidget extends StatelessWidget {
  const NoNewsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.assessment,
            color: Theme.of(context).colorScheme.primary,
            size: 100,
          ),
          Text(
            tr("news.no_news_follow_more"),
            style: TextStyle(
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
