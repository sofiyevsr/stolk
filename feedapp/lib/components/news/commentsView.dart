import 'dart:async';

import 'package:feedapp/components/common/centerLoadingWidget.dart';
import 'package:feedapp/components/news/singleComment.dart';
import 'package:feedapp/logic/blocs/commentsBloc/comments.dart';
import 'package:feedapp/utils/debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'animatedSingleComment.dart';
import 'commentInput.dart';

class CommentsView extends StatefulWidget {
  final int id;
  const CommentsView({Key? key, required this.id}) : super(key: key);

  @override
  _CommentsViewState createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  bool hasAnimatedNew = false;
  ScrollController _scrollController = ScrollController();

  Debounce _debouncer = Debounce(
    duration: const Duration(milliseconds: 75),
  );
  @override
  void initState() {
    super.initState();
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
    super.dispose();
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
          AppBar(),
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
                          physics: ClampingScrollPhysics(),
                          reverse: true,
                          itemCount: state.data.hasReachedEnd
                              ? state.data.comments.length
                              : state.data.comments.length + 1,
                          itemBuilder: (ctx, index) {
                            return index >= state.data.comments.length
                                ? state is CommentsNextFetchError
                                    ? Container(
                                        height: 50,
                                        child: Center(
                                          child: ElevatedButton(
                                            onPressed: forceFetchNext,
                                            child: Text("missing"),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 50,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
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
                        onEnd: () {
                          setState(() {
                            hasAnimatedNew = false;
                          });
                        },
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
