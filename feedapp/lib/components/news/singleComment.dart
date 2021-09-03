import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/utils/@types/response/comments.dart';
import 'package:stolk/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const MAX_COMMENT_LENGTH = 100;

class SingleCommentView extends StatefulWidget {
  final SingleComment comment;
  const SingleCommentView({Key? key, required this.comment}) : super(key: key);

  @override
  _SingleCommentViewState createState() => _SingleCommentViewState();
}

class _SingleCommentViewState extends State<SingleCommentView> {
  bool _isExtended = false;
  late TapGestureRecognizer _showMoreRecognizer;

  @override
  void initState() {
    super.initState();
    _showMoreRecognizer = TapGestureRecognizer()..onTap = _handlePress;
  }

  @override
  void dispose() {
    _showMoreRecognizer.dispose();
    super.dispose();
  }

  void _handlePress() {
    setState(() {
      _isExtended = true;
    });
  }

  String shortenComment(String comment) {
    if (comment.length > MAX_COMMENT_LENGTH) {
      return comment.substring(0, MAX_COMMENT_LENGTH) + "...";
    }
    return comment;
  }

  @override
  Widget build(BuildContext context) {
    final fullName =
        "${widget.comment.firstName ?? ""} ${widget.comment.lastName ?? ""}";
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              if (state is AuthorizedState) {
                return CircleAvatar(
                  child: Text(state.user.firstName[0]),
                );
              }
              return CircleAvatar(
                child: Text(widget.comment.firstName?[0] ?? ""),
              );
            }),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            BlocBuilder<AuthBloc, AuthState>(
                                builder: (ctx, state) {
                              if (state is AuthorizedState) {
                                if (state.user.id == widget.comment.userID) {
                                  return Text(
                                      tr(
                                        "commons.me",
                                      ),
                                      style: textTheme.subtitle1);
                                }
                              }
                              return Text(
                                fullName,
                                style: textTheme.subtitle1,
                              );
                            }),
                            Text(
                              convertDiffTime(
                                  widget.comment.createdAt, context),
                              style: textTheme.subtitle2,
                            ),
                          ],
                        )
                      ],
                    ),
                    PopupMenuButton(itemBuilder: (ctx) => []),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: _isExtended
                                ? widget.comment.comment
                                : shortenComment(widget.comment.comment),
                            style: textTheme.bodyText2?.copyWith(fontSize: 16),
                          ),
                          if (_isExtended == false &&
                              widget.comment.comment.length >
                                  MAX_COMMENT_LENGTH)
                            TextSpan(
                              text: ' ${tr("commons.show_more")}',
                              recognizer: _showMoreRecognizer,
                              style: textTheme.bodyText2?.copyWith(
                                  fontSize: 18, color: Colors.grey[400]),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
