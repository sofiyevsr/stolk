import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/screens/feed/widgets/singleNewsActions.dart';
import 'package:stolk/screens/feed/widgets/singleNewsHeader.dart';
import 'package:stolk/utils/@types/response/allNews.dart';
import 'package:flutter/material.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import 'package:stolk/utils/ui/constants.dart';

import 'newsView.dart';
import 'singleNewsBody.dart';

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
    if (feed.readID == null) {
      newsService.markRead(feed.id).then((value) {
        final userBloc = BlocProvider.of<AuthBloc>(context);
        if (userBloc.state is AuthorizedState) {
          final newsBloc = BlocProvider.of<NewsBloc>(context);
          newsBloc.add(
            NewsActionEvent(index: index, type: NewsActionType.READ),
          );
        }
      }).catchError((_) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
        child: Container(
          height: SINGLE_NEWS_HEIGHT,
          decoration: BoxDecoration(
            color: theme.cardColor,
          ),
          child: Material(
            child: InkWell(
              onTap: () => _goToNewsWebview(context),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        SingleNewsBody(feed: feed, index: index),
                        SingleNewsHeader(feed: feed, index: index),
                      ],
                    ),
                  ),
                  SingleNewsActions(feed: feed, index: index),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
