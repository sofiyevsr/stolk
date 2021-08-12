import 'package:stolk/components/common/notFoundImage.dart';
import 'package:stolk/screens/feed/widgets/newsView.dart';
import 'package:stolk/screens/feed/widgets/singleNewsActions.dart';
import 'package:stolk/screens/feed/widgets/singleNewsHeader.dart';
import 'package:stolk/utils/@types/response/allNews.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import 'package:stolk/utils/transparentImage.dart';
import 'package:flutter/material.dart';

const NEWS_HEIGHT = 300.0;

class SingleNewsView extends StatelessWidget {
  final SingleNews feed;
  final int index;
  const SingleNewsView({Key? key, required this.feed, required this.index})
      : super(key: key);

  Widget _buildNews(ThemeData theme) {
    return Container(
      height: NEWS_HEIGHT,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: theme.cardColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            NavigationService.push(
                NewsView(link: feed.feedLink), RouteNames.SINGLE_NEWS);
          },
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
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
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            feed.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SingleNewsHeader(feed: this.feed, index: index),
        _buildNews(theme),
        SingleNewsActions(feed: this.feed, index: index),
      ],
    );
  }
}
