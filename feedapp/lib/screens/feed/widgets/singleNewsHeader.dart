import 'package:feedapp/components/common/scaleButton.dart';
import 'package:feedapp/utils/@types/response/allNews.dart';
import 'package:feedapp/utils/common.dart';
import 'package:flutter/material.dart';

class SingleNewsHeader extends StatelessWidget {
  final SingleNews feed;
  const SingleNewsHeader({Key? key, required this.feed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(),
            ),
            Column(
              children: [
                Text(
                  this.feed.sourceName,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headline6?.copyWith(fontSize: 18),
                ),
                Text(
                  convertDiffTime(this.feed.publishedDate, context),
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.subtitle2?.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            ScaleButton(
              child: Icon(
                Icons.add,
                size: 32,
              ),
              onFinish: () {},
            ),
            PopupMenuButton(
              iconSize: 32,
              offset: Offset(0, 40),
              itemBuilder: (entry) {
                return [
                  PopupMenuItem(
                    child: Text("test"),
                  ),
                ];
              },
            ),
          ],
        ),
      ],
    );
  }
}
