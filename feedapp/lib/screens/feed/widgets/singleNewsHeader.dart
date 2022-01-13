import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:like_button/like_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stolk/components/common/sourceLogo.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/screens/feed/sourceNews.dart';
import 'package:stolk/utils/@types/response/allNews.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import 'package:stolk/utils/services/server/newsService.dart';
import 'package:flutter/material.dart';
import 'package:stolk/utils/ui/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final news = NewsService();
const _iconSize = 30.0;
const _buttonPadding = 2.5;

class SingleNewsHeader extends StatelessWidget {
  final SingleNews feed;
  final int index;
  final int? bookmarkID;
  SingleNewsHeader({Key? key, required this.feed, required this.index})
      : bookmarkID = feed.bookmarkID,
        super(key: key);

  void _share() {
    Share.share(feed.feedLink);
  }

  Widget _buildShareButton() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(_iconSize + _buttonPadding),
        ),
      ),
      child: IconButton(
        iconSize: _iconSize,
        padding: const EdgeInsets.all(0),
        icon: const Icon(Icons.share_outlined),
        onPressed: _share,
      ),
    );
  }

  Widget _buildBookmarkButton(BuildContext context) {
    final bubbleColor = Colors.blue;
    return LikeButton(
      padding: const EdgeInsets.all(_buttonPadding + 2),
      size: _iconSize + _buttonPadding,
      isLiked: bookmarkID != null,
      bubblesColor: BubblesColor(
        dotPrimaryColor: bubbleColor,
        dotSecondaryColor: bubbleColor,
      ),
      likeBuilder: (isBookmarked) {
        if (isBookmarked) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(_iconSize + _buttonPadding),
              ),
            ),
            child: Icon(
              Icons.bookmark_added_outlined,
              color: bubbleColor,
              size: _iconSize,
            ),
          );
        } else {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(_iconSize + _buttonPadding),
              ),
            ),
            child: const Icon(
              Icons.bookmark_add_outlined,
              size: _iconSize,
            ),
          );
        }
      },
      onTap: (isBookmarked) => _bookmark(context, isBookmarked),
    );
  }

  Future<bool> _bookmark(BuildContext context, bool bookmarked) async {
    final newsBloc = context.read<NewsBloc>();
    try {
      if (bookmarked) {
        await news.unbookmark(feed.id);
        newsBloc.add(
          NewsActionEvent(index: index, type: NewsActionType.UNBOOKMARK),
        );
        return false;
      } else {
        await news.bookmark(feed.id);
        newsBloc.add(
          NewsActionEvent(index: index, type: NewsActionType.BOOKMARK),
        );
        return true;
      }
    } catch (e) {
      return bookmarked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: HEADER_HEIGHT,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              NavigationService.push(
                SourceNewsScreen(
                  sourceID: feed.sourceID,
                  sourceName: feed.sourceName,
                  logoSuffix: feed.sourceLogoSuffix,
                ),
                RouteNames.SOURCE_NEWS_FEED,
              );
            },
            child: Row(
              children: [
                SizedBox(
                  height: 65,
                  width: 65,
                  child: SourceLogo(
                    isCircle: true,
                    logoSuffix: feed.sourceLogoSuffix,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(
                      feed.sourceName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: theme.textTheme.headline6?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Tooltip(
                message: tr("tooltips.bookmark"),
                child: _buildBookmarkButton(context),
              ),
              Tooltip(
                message: tr("tooltips.share"),
                child: _buildShareButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
