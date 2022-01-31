import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:stolk/components/common/dialogs/reportDialog.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/utils/@types/response/comments.dart';
import 'package:stolk/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/utils/services/server/reportService.dart';

const MAX_COMMENT_LENGTH = 100;

class SingleCommentView extends StatefulWidget {
  final SingleComment comment;
  const SingleCommentView({Key? key, required this.comment}) : super(key: key);

  @override
  _SingleCommentViewState createState() => _SingleCommentViewState();
}

class _SingleCommentViewState extends State<SingleCommentView> {
  final reportApi = ReportService();
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
      margin: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(6.0),
            child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              if (state is AuthorizedState) {
                return CircleAvatar(
                  radius: 24,
                  child: Text(state.user.firstName[0]),
                );
              } else {
                return CircleAvatar(
                  radius: 24,
                  child: Text(widget.comment.firstName?[0] ?? ""),
                );
              }
            }),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (ctx, state) {
                          if (state is AuthorizedState) {
                            if (state.user.id == widget.comment.userID) {
                              return Text(
                                tr(
                                  "commons.me",
                                ),
                                style: textTheme.bodyText1,
                                maxLines: 3,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                              );
                            }
                          }
                          return Text(
                            fullName,
                            style: textTheme.bodyText1,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          );
                        }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            convertDiffTime(
                              widget.comment.createdAt,
                              context,
                              short: true,
                            ),
                            style: textTheme.bodyText2?.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                          PopupMenuButton<String>(
                            offset: const Offset(-32, 0),
                            padding: const EdgeInsets.all(0),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                Icons.more_vert_sharp,
                                size: 32,
                              ),
                            ),
                            onSelected: (v) async {
                              try {
                                authorize();
                                await showDialog(
                                  context: context,
                                  builder: (ctx) => ReportDialog(
                                    onConfirmed: (message) async {
                                      await reportApi.commentReport(
                                          message, widget.comment.id);
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
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: _isExtended
                                    ? widget.comment.comment
                                    : shortenComment(widget.comment.comment),
                                style:
                                    textTheme.bodyText2?.copyWith(fontSize: 15),
                              ),
                              if (_isExtended == false &&
                                  widget.comment.comment.length >
                                      MAX_COMMENT_LENGTH)
                                TextSpan(
                                  text: ' ${tr("commons.show_more")}',
                                  recognizer: _showMoreRecognizer,
                                  style: textTheme.bodyText2?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.blue[700]),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
