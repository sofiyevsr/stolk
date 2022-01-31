import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/components/common/centerLoadingWidget.dart';
import 'package:stolk/components/common/noConnection.dart';
import 'package:stolk/components/comment/animatedSingleComment.dart';
import 'package:stolk/components/comment/commentInput.dart';
import 'package:stolk/components/comment/singleComment.dart';
import 'package:stolk/logic/blocs/commentsBloc/comments.dart';
import 'package:stolk/utils/debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentsView extends StatefulWidget {
  final int id;
  final Function() onNewComment;
  const CommentsView({
    Key? key,
    required this.onNewComment,
    required this.id,
  }) : super(key: key);

  @override
  _CommentsViewState createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  String? _errorMessage;
  Timer? _errorTimer;
  bool hasAnimatedNew = false;
  ScrollController _scrollController = ScrollController();

  final Debounce _debouncer = Debounce(
    duration: const Duration(milliseconds: 75),
  );
  @override
  void initState() {
    super.initState();
    initialFetch();
    _scrollController.addListener(
      () {
        _debouncer.run(
          () {
            final maxScroll = _scrollController.position.maxScrollExtent;
            final currentScroll = _scrollController.position.pixels;
            if (maxScroll - currentScroll <= 300) {
              context.read<CommentsBloc>().add(
                    FetchNextCommentsEvent(
                      id: widget.id,
                    ),
                  );
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _scrollController.dispose();
    _errorTimer?.cancel();
    super.dispose();
  }

  void initialFetch() {
    context.read<CommentsBloc>().add(
          FetchCommentsEvent(id: widget.id),
        );
  }

  void handleError(dynamic e) {
    if (e is! DioError || _errorMessage != null || mounted == false) return;
    if (e.response == null) {
      setState(() {
        _errorMessage = tr("errors.network_error");
      });
      hideErrorMessage();
      return;
    }
    final message = "server_errors.${e.response?.data['message']}";
    if (tr(message) == message) {
      setState(() {
        _errorMessage = tr("errors.default");
      });
    } else {
      setState(() {
        _errorMessage = tr(message);
      });
    }
    hideErrorMessage();
  }

  void hideErrorMessage() {
    _errorTimer = Timer(const Duration(milliseconds: 1750), () {
      if (mounted)
        setState(() {
          _errorMessage = null;
        });
    });
  }

  void forceFetchNext() {
    BlocProvider.of<CommentsBloc>(context).add(
      FetchNextCommentsEvent(
        id: widget.id,
        force: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final newsID = widget.id;
    return SafeArea(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                title: Text(
                  tr("commons.comments"),
                ),
              ),
              AnimatedContainer(
                child: Text(
                  _errorMessage ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.center,
                color: Colors.red,
                height: _errorMessage == null ? 0 : 40,
              ),
            ],
          ),
          Expanded(
            child: BlocBuilder<CommentsBloc, CommentsState>(
              builder: (ctx, state) {
                if (state is CommentsStateLoading) return CenterLoadingWidget();
                if (state is CommentsStateWithData) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: const ClampingScrollPhysics(),
                          reverse: true,
                          itemCount: state.data.hasReachedEnd
                              ? state.data.comments.length
                              : state.data.comments.length + 1,
                          itemBuilder: (ctx, index) {
                            return index >= state.data.comments.length
                                ? state is CommentsNextFetchError
                                    ? SizedBox(
                                        height: 50,
                                        child: Center(
                                          child: ElevatedButton(
                                            onPressed: forceFetchNext,
                                            child: Text(
                                              tr("buttons.retry_request"),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(
                                        height: 50,
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: CircularProgressIndicator
                                                .adaptive(
                                              strokeWidth: 3,
                                            ),
                                          ),
                                        ),
                                      )
                                : AnimatedSingleComment(
                                    key: Key(
                                      state.data.comments[index].id.toString(),
                                    ),
                                    shouldAnimate: index == 0 &&
                                        state.data.comments[index].isManual ==
                                            true &&
                                        hasAnimatedNew == false,
                                    onEnd: () {
                                      setState(() {
                                        hasAnimatedNew = true;
                                      });
                                    },
                                    child: SingleCommentView(
                                      comment: state.data.comments[index],
                                    ),
                                  );
                          },
                        ),
                      ),
                      CommentInput(
                        newsID: newsID,
                        onError: handleError,
                        onEnd: () {
                          setState(() {
                            hasAnimatedNew = false;
                          });
                          widget.onNewComment();
                        },
                      ),
                    ],
                  );
                }
                if (state is CommentsStateError)
                  return NoConnectionWidget(onRetry: initialFetch);
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
