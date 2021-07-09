import 'dart:async';

import 'package:feedapp/logic/blocs/newsBloc/utils/NewsBloc.dart';
import 'package:feedapp/screens/feed/widgets/categoryList.dart';
import 'package:feedapp/screens/feed/widgets/singleNews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const SINGLE_NEWS_HEIGHT = 150.0;

class AllNewsScreen extends StatefulWidget {
  const AllNewsScreen({Key? key}) : super(key: key);

  @override
  _AllNewsScreenState createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
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
          Duration(milliseconds: 80),
          () {
            final maxScroll = _scrollController.position.maxScrollExtent;
            final currentScroll = _scrollController.position.pixels;
            if (maxScroll - currentScroll <= SINGLE_NEWS_HEIGHT) {
              context.read<NewsBloc>().add(
                    FetchNextNewsEvent(),
                  );
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            CategoryList(),
            Expanded(
              child: BlocBuilder<NewsBloc, NewsState>(
                builder: (ctx, state) {
                  if (state is NewsStateSuccess) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        NewsBloc()
                          ..add(
                            FetchNewsEvent(),
                          );
                      },
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        controller: _scrollController,
                        itemExtent: SINGLE_NEWS_HEIGHT,
                        itemCount: state.data.hasReachedEnd
                            ? state.data.news.length
                            : state.data.news.length + 1,
                        itemBuilder: (ctx, index) =>
                            index >= state.data.news.length
                                ? Center(
                                    child: CircularProgressIndicator.adaptive(
                                      strokeWidth: 10,
                                    ),
                                  )
                                : SingleNewsView(
                                    key: Key(
                                      state.data.news[index].id.toString(),
                                    ),
                                    feed: state.data.news[index],
                                  ),
                      ),
                    );
                  }
                  if (state is NewsStateLoading)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  if (state is NewsStateNoData) {}
                  if (state is NewsStateError) {}
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
