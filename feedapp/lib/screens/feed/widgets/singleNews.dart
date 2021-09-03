import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/components/common/notFoundImage.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/screens/feed/widgets/newsView.dart';
import 'package:stolk/screens/feed/widgets/singleNewsActions.dart';
import 'package:stolk/screens/feed/widgets/singleNewsHeader.dart';
import 'package:stolk/utils/@types/response/allNews.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import 'package:stolk/utils/services/server/newsService.dart';
import 'package:stolk/utils/transparentImage.dart';
import 'package:flutter/material.dart';

const NEWS_HEIGHT = 300.0;

final newsService = NewsService();

class SingleNewsView extends StatelessWidget {
  final SingleNews feed;
  final int index;
  const SingleNewsView({Key? key, required this.feed, required this.index})
      : super(key: key);

  void _goToNewsWebview(BuildContext context) {
    NavigationService.push(
      NewsView(link: feed.feedLink),
      RouteNames.SINGLE_NEWS,
    );
    if (feed.readID == null)
      newsService.markRead(this.feed.id).then((value) {
        final newsBloc = BlocProvider.of<NewsBloc>(context);
        newsBloc.add(
          NewsActionEvent(index: index, type: NewsActionType.READ),
        );
      }).catchError((e) {
        FirebaseCrashlytics.instance
            .log('Couldn\'t mark news read ${e.toString}');
      });
  }

  Widget _buildNews(BuildContext context) {
    final theme = Theme.of(context);
    final readBefore = feed.readID != null;
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
          onTap: () => _goToNewsWebview(context),
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        feed.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: readBefore ? Colors.grey : null,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
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
    return Column(
      children: [
        SingleNewsHeader(feed: this.feed, index: index),
        _buildNews(context),
        SingleNewsActions(feed: this.feed, index: index),
      ],
    );
  }
}
