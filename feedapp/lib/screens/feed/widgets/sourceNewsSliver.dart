import 'dart:async';

import 'package:feedapp/components/common/centerLoadingWidget.dart';
import 'package:feedapp/logic/blocs/newsBloc/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'singleNews.dart';

const SINGLE_NEWS_HEIGHT = 400;

class SourceNewsSliver extends StatefulWidget {
  final ScrollController scrollController;
  final int sourceID;
  const SourceNewsSliver(
      {Key? key, required this.scrollController, required this.sourceID})
      : super(key: key);

  @override
  _SourceNewsSliverState createState() => _SourceNewsSliverState();
}

class _SourceNewsSliverState extends State<SourceNewsSliver> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(
      () {
        // Debounce
        if (_timer != null && _timer!.isActive) _timer!.cancel();
        _timer = Timer(
          Duration(milliseconds: 50),
          () {
            final maxScroll = widget.scrollController.position.maxScrollExtent;
            final currentScroll = widget.scrollController.position.pixels;
            if (maxScroll - currentScroll <= SINGLE_NEWS_HEIGHT * 3) {
              context.read<NewsBloc>().add(
                    FetchNextNewsEvent(
                      category: null,
                      sourceID: widget.sourceID,
                      filterBy: null,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (ctx, state) {
        if (state is NewsStateLoading)
          return SliverFillRemaining(
            child: CenterLoadingWidget(),
          );
        if (state is NewsStateSuccess) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, index) => index >= state.data.news.length
                  ? Container(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 8,
                        ),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: SingleNewsView(
                        key: Key(
                          state.data.news[index].id.toString(),
                        ),
                        feed: state.data.news[index],
                        index: index,
                      ),
                    ),
              childCount: state.data.hasReachedEnd
                  ? state.data.news.length
                  : state.data.news.length + 1,
            ),
          );
        }

        if (state is NewsStateNoData) {}
        if (state is NewsStateError) {}
        return SliverFillRemaining(
          child: Container(),
        );
      },
    );
  }
}
