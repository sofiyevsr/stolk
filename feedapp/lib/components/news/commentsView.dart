import 'dart:async';

import 'package:feedapp/components/common/centerLoadingWidget.dart';
import 'package:feedapp/components/news/singleComment.dart';
import 'package:feedapp/logic/blocs/commentsBloc/comments.dart';
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

  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () {
        // Debounce
        if (_timer != null && _timer!.isActive) _timer!.cancel();
        _timer = Timer(
          Duration(milliseconds: 50),
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
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
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
                if (state is CommentsStateSuccess) {
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
                                ? Container(
                                    height: 50,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child:
                                            CircularProgressIndicator.adaptive(
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
