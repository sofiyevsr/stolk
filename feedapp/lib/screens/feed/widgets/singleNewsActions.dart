import 'package:feedapp/components/news/commentsView.dart';
import 'package:feedapp/logic/blocs/commentsBloc/comments.dart';
import 'package:feedapp/utils/@types/response/allNews.dart';
import 'package:feedapp/utils/services/server/newsService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';

final news = NewsService();
const _iconSize = 36.0;

class SingleNewsActions extends StatefulWidget {
  final int newsID;
  final String newsURL;
  final int? bookmarkID;
  final int? likeID;
  final int? likeCount;
  SingleNewsActions({
    Key? key,
    required SingleNews feed,
  })  : newsID = feed.id,
        newsURL = feed.feedLink,
        bookmarkID = feed.bookmarkID,
        likeID = feed.likeID,
        likeCount = feed.likeCount,
        super(key: key);

  @override
  _SingleNewsActionsState createState() => _SingleNewsActionsState();
}

class _SingleNewsActionsState extends State<SingleNewsActions> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildLikeButton() {
    final bool _isLiked = widget.likeID != null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LikeButton(
        size: _iconSize,
        likeCount: widget.likeCount,
        isLiked: _isLiked,
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
        onTap: _like,
      ),
    );
  }

  Widget _buildBookmarkButton() {
    final bool _isBookmarked = widget.bookmarkID != null;
    final bubbleColor = Colors.blue;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LikeButton(
        padding: const EdgeInsets.all(0),
        size: _iconSize,
        isLiked: _isBookmarked,
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
        onTap: _bookmark,
      ),
    );
  }

  Widget _buildIconButton(IconData icon, void Function() onPressed) {
    return IconButton(
      iconSize: _iconSize,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      icon: Icon(icon),
      onPressed: onPressed,
    );
  }

  Future<bool> _like(bool isLiked) async {
    try {
      if (isLiked) {
        await news.unlike(widget.newsID);
        return false;
      } else {
        await news.like(widget.newsID);
        return true;
      }
    } catch (e) {
      return isLiked;
    }
  }

  Future<bool> _bookmark(bool bookmarked) async {
    try {
      if (bookmarked) {
        await news.unbookmark(widget.newsID);
        return false;
      } else {
        await news.bookmark(widget.newsID);
        return true;
      }
    } catch (e) {
      return bookmarked;
    }
  }

  void _comment() {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        final id = widget.newsID;
        return BlocProvider(
          create: (ctx) => CommentsBloc()
            ..add(
              FetchCommentsEvent(id: id),
            ),
          child: CommentsView(id: id),
        );
      },
    );
  }

  void _share() {
    Share.share(widget.newsURL);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ButtonTheme(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  _buildLikeButton(),
                  _buildIconButton(Icons.comment_outlined, _comment),
                ],
              ),
            ),
            Row(
              children: [
                _buildBookmarkButton(),
                _buildIconButton(Icons.share_outlined, _share),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
