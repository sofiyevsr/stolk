import 'package:stolk/screens/feed/widgets/singleNewsActions.dart';
import 'package:stolk/screens/feed/widgets/singleNewsHeader.dart';
import 'package:stolk/utils/@types/response/allNews.dart';
import 'package:flutter/material.dart';

import 'singleNewsBody.dart';

class SingleNewsView extends StatelessWidget {
  final SingleNews feed;
  final int index;
  const SingleNewsView({Key? key, required this.feed, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          SingleNewsHeader(feed: this.feed, index: index),
          SingleNewsBody(feed: feed, index: index),
          SingleNewsActions(feed: this.feed, index: index),
        ],
      ),
    );
  }
}
