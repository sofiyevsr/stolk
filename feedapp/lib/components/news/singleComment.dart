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
          Container(
            constraints: BoxConstraints(maxWidth: 120),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                    if (state is AuthorizedState) {
                      return CircleAvatar(
                        child: Text(
                          state.user.firstName[0],
                        ),
                      );
                    }
                    return CircleAvatar(
                      child: Text(widget.comment.firstName?[0] ?? ""),
                    );
                  }),
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 80),
                  margin: const EdgeInsets.only(right: 5),
                  child:
                      BlocBuilder<AuthBloc, AuthState>(builder: (ctx, state) {
                    if (state is AuthorizedState) {
                      if (state.user.id == widget.comment.userID) {
                        return Text(
                          tr(
                            "commons.me",
                          ),
                          style: textTheme.bodyText2,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                    }
                    return Text(
                      fullName,
                      style: textTheme.bodyText2,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).cardColor,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            convertDiffTime(widget.comment.createdAt, context),
                            style: textTheme.bodyText1?.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: _isExtended
                                        ? widget.comment.comment
                                        : shortenComment(
                                            widget.comment.comment),
                                    style: textTheme.bodyText2
                                        ?.copyWith(fontSize: 15),
                                  ),
                                  if (_isExtended == false &&
                                      widget.comment.comment.length >
                                          MAX_COMMENT_LENGTH)
                                    TextSpan(
                                      text: ' ${tr("commons.show_more")}',
                                      recognizer: _showMoreRecognizer,
                                      style: textTheme.bodyText2?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.blue[700]),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      offset: Offset(-40, 0),
                      iconSize: 30,
                      onSelected: (v) async {
                        await showDialog(
                          context: context,
                          builder: (ctx) => ReportDialog(
                            onConfirmed: (message) {
                              final api = ReportService();
                              return api.commentReport(
                                  message, widget.comment.id);
                            },
                          ),
                        );
                      },
                      itemBuilder: (entry) {
                        return [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: Icon(Icons.report, color: Colors.red),
                                ),
                                Text(
                                  tr("report.menu"),
                                ),
                              ],
                            ),
                            value: "report",
                          ),
                        ];
                      },
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
