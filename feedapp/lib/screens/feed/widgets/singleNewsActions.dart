import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/components/common/dialogs/reportDialog.dart';
import 'package:stolk/logic/blocs/commentsBloc/comments.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/utils/@types/response/allNews.dart';
import 'package:stolk/utils/common.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/server/newsService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stolk/utils/services/server/reportService.dart';
import 'package:stolk/utils/ui/constants.dart';
import 'package:stolk/views/CommentsView.dart';

final news = NewsService();
final reportApi = ReportService();
const _iconSize = 30.0;

class SingleNewsActions extends StatelessWidget {
  final int index;
  final int newsID;
  final String newsURL;
  final int? likeID;
  final int? likeCount;
  final int? commentCount;
  SingleNewsActions({
    Key? key,
    required SingleNews feed,
    required this.index,
  })  : newsID = feed.id,
        newsURL = feed.feedLink,
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
            return const Icon(
              Icons.favorite_sharp,
              color: CustomColorScheme.accent,
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

  void _comment(BuildContext context) {
    final newsBloc = context.read<NewsBloc>();
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (ctx) => CommentsBloc(),
          child: CommentsView(
              id: newsID,
              onNewComment: () {
                newsBloc.add(
                  NewsActionEvent(
                    index: index,
                    type: NewsActionType.COMMENT,
                  ),
                );
              }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ACTIONS_HEIGHT,
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
            PopupMenuButton<String>(
              offset: const Offset(0, 32),
              iconSize: _iconSize,
              onSelected: (v) async {
                try {
                  authorize();
                  await showDialog(
                    context: context,
                    builder: (ctx) => ReportDialog(
                      onConfirmed: (String message) {
                        return reportApi.newsReport(message, newsID);
                      },
                    ),
                  );
                } catch (_) {}
              },
              itemBuilder: (entry) {
                return [
                  PopupMenuItem(
                    height: 32,
                    child: Text(
                      tr("report.menu"),
                    ),
                    value: "report",
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}
