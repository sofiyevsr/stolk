import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:stolk/components/common/notFoundImage.dart';
import 'package:stolk/utils/@types/response/allNews.dart';
import 'package:stolk/utils/common.dart';
import 'package:stolk/utils/transparentImage.dart';

class SingleNewsBody extends StatelessWidget {
  final SingleNews feed;
  final int index;
  const SingleNewsBody({Key? key, required this.feed, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final readBefore = feed.readID != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 10,
          child: feed.imageLink == null
              ? NotFoundImage(color: theme.primaryColor)
              : FadeInImage.memoryNetwork(
                  image: feed.imageLink!,
                  placeholder: transparentPlaceholder,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (ctx, err, _) =>
                      NotFoundImage(color: theme.primaryColor),
                ),
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.centerRight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.history_outlined),
              AutoSizeText(
                convertDiffTime(feed.publishedDate, context),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: theme.textTheme.bodyText2?.copyWith(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                feed.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: readBefore ? Colors.grey : null,
                ),
                minFontSize: 12,
                maxLines: 3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
