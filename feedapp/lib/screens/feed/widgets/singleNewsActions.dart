import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/logic/blocs/commentsBloc/comments.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/utils/@types/response/allNews.dart';
import 'package:stolk/utils/services/server/newsService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stolk/utils/ui/constants.dart';
import 'package:stolk/views/CommentsView.dart';

final news = NewsService();
const _iconSize = 30.0;

class SingleNewsActions extends StatelessWidget {
  final int index;
  final int newsID;
  final String newsURL;
  final int? bookmarkID;
  final int? likeID;
  final int? likeCount;
  final int? commentCount;
  SingleNewsActions({
    Key? key,
    required SingleNews feed,
    required this.index,
  })  : newsID = feed.id,
        newsURL = feed.feedLink,
        bookmarkID = feed.bookmarkID,
        likeID = feed.likeID,
        likeCount = feed.likeCount,
        commentCount = feed.commentCount,
        super(key: key);

  Widget _buildLikeButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LikeButton(
        size: _iconSize,
        likeCount: likeCount,
        isLiked: likeID != null,
        likeBuilder: (isLiked) {
          if (isLiked)
            return Icon(
              Icons.favorite_sharp,
              color: Colors.red,
              size: _iconSize,
            );
          else {
            return Icon(
              Icons.favorite_border,
              size: _iconSize,
            );
          }
        },
        onTap: (isLiked) => _like(context, isLiked),
      ),
    );
  }

  Widget _buildBookmarkButton(BuildContext context) {
    final bubbleColor = Colors.blue;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LikeButton(
        padding: const EdgeInsets.all(0),
        size: _iconSize,
        isLiked: bookmarkID != null,
        bubblesColor: BubblesColor(
          dotPrimaryColor: bubbleColor,
          dotSecondaryColor: bubbleColor,
        ),
        likeBuilder: (isBookmarked) {
          if (isBookmarked)
            return Icon(
              Icons.bookmark_added_outlined,
              color: bubbleColor,
              size: _iconSize,
            );
          else {
            return Icon(
              Icons.bookmark_add_outlined,
              size: _iconSize,
            );
          }
        },
        onTap: (isBookmarked) => _bookmark(context, isBookmarked),
      ),
    );
  }

  Widget _buildIconButton({
    required Widget icon,
    required void Function() onPressed,
  }) {
    return IconButton(
      iconSize: _iconSize,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      icon: icon,
      onPressed: onPressed,
    );
  }

  Widget _buildCommentButton({
    required void Function() onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              size: _iconSize - 3,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Text(
                commentCount.toString(),
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _like(BuildContext context, bool isLiked) async {
    final newsBloc = context.read<NewsBloc>();
    try {
      if (isLiked) {
        await news.unlike(newsID);
        newsBloc.add(
          NewsActionEvent(index: index, type: NewsActionType.UNLIKE),
        );
        return false;
      } else {
        await news.like(newsID);
        newsBloc.add(
          NewsActionEvent(index: index, type: NewsActionType.LIKE),
        );
        return true;
      }
    } catch (e) {
      return isLiked;
    }
  }

  Future<bool> _bookmark(BuildContext context, bool bookmarked) async {
    final newsBloc = context.read<NewsBloc>();
    try {
      if (bookmarked) {
        await news.unbookmark(newsID);
        newsBloc.add(
          NewsActionEvent(index: index, type: NewsActionType.UNBOOKMARK),
        );
        return false;
      } else {
        await news.bookmark(newsID);
        newsBloc.add(
          NewsActionEvent(index: index, type: NewsActionType.BOOKMARK),
        );
        return true;
      }
    } catch (e) {
      return bookmarked;
    }
  }

  void _comment(BuildContext context) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (ctx) => CommentsBloc(),
          child: CommentsView(id: newsID),
        );
      },
    );
  }

  void _share() {
    Share.share(newsURL);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: ACTIONS_HEIGHT,
      color: theme.cardColor,
      child: ButtonTheme(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Tooltip(
                  message: tr("tooltips.like"),
                  child: _buildLikeButton(context),
                ),
                Tooltip(
                  message: tr("tooltips.comment"),
                  child: _buildCommentButton(
                    onPressed: () => _comment(context),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Tooltip(
                  message: tr("tooltips.bookmark"),
                  child: _buildBookmarkButton(context),
                ),
                Tooltip(
                  message: tr("tooltips.share"),
                  child: _buildIconButton(
                    icon: Icon(Icons.share_outlined),
                    onPressed: _share,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
