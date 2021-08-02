import 'dart:async';

import 'package:feedapp/components/common/centerLoadingWidget.dart';
import 'package:feedapp/logic/blocs/newsBloc/news.dart';
import 'package:feedapp/screens/feed/widgets/singleNews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const SINGLE_NEWS_HEIGHT = 400.0;

class SingleNewsHistoryUnit extends StatefulWidget {
  final String filterBy;
  const SingleNewsHistoryUnit({Key? key, required this.filterBy})
      : super(key: key);

  @override
  _SingleNewsHistoryUnitState createState() => _SingleNewsHistoryUnitState();
}

class _SingleNewsHistoryUnitState extends State<SingleNewsHistoryUnit> {
  late ScrollController _scrollController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(
      () {
        // Debounce
        if (_timer != null && _timer!.isActive) _timer!.cancel();
        _timer = Timer(
          Duration(milliseconds: 50),
          () {
            final maxScroll = _scrollController.position.maxScrollExtent;
            final currentScroll = _scrollController.position.pixels;
            if (maxScroll - currentScroll <= SINGLE_NEWS_HEIGHT * 3) {
              context.read<NewsBloc>().add(
                    FetchNextNewsEvent(
                      category: null,
                      sourceID: null,
                      filterBy: widget.filterBy,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: BlocBuilder<NewsBloc, NewsState>(
        builder: (ctx, state) {
          if (state is NewsStateLoading) return CenterLoadingWidget();
          if (state is NewsStateSuccess) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              itemCount: state.data.hasReachedEnd
                  ? state.data.news.length
                  : state.data.news.length + 1,
              itemBuilder: (ctx, index) => index >= state.data.news.length
                  ? Container(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 8,
                        ),
                      ),
                    )
                  : SingleNewsView(
                      key: Key(
                        state.data.news[index].id.toString(),
                      ),
                      feed: state.data.news[index],
                      index: index,
                    ),
            );
          }

          if (state is NewsStateNoData) {}
          if (state is NewsStateError) {}
          return Container();
        },
      ),
    );
  }
}
