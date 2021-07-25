import 'dart:async';

import 'package:feedapp/logic/blocs/newsBloc/utils/NewsBloc.dart';
import 'package:feedapp/screens/feed/widgets/categoryList.dart';
import 'package:feedapp/screens/feed/widgets/singleNews.dart';
import 'package:feedapp/screens/feed/widgets/singleNewsShimmer.dart';
import 'package:feedapp/utils/services/server/newsService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const SINGLE_NEWS_HEIGHT = 400.0;

final service = NewsService();

class AllNewsScreen extends StatefulWidget {
  const AllNewsScreen({Key? key}) : super(key: key);

  @override
  _AllNewsScreenState createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  ScrollController _scrollController = ScrollController();
  int _currentCategory = 0;

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
            if (maxScroll - currentScroll <= SINGLE_NEWS_HEIGHT * 3) {
              context.read<NewsBloc>().add(
                    FetchNextNewsEvent(
                      category: _currentCategory,
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

  Future<void> onRefresh() async {
    try {
      final data = await service.getAllNews(null, _currentCategory);
      BlocProvider.of<NewsBloc>(context).add(
        RefreshNewsEvent(
          data: data,
        ),
      );
    } catch (e) {}
  }

  void _changeCategory(int id) {
    _scrollController.jumpTo(
      0,
    );
    final bloc = context.read<NewsBloc>();
    bloc.add(
      FetchNewsEvent(
        category: id,
      ),
    );
    setState(() {
      _currentCategory = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            CategoryList(
              current: _currentCategory,
              changeCategory: _changeCategory,
            ),
            Expanded(
              child: BlocBuilder<NewsBloc, NewsState>(
                builder: (ctx, state) {
                  if (state is NewsStateLoading) return SingleNewsShimmer();
                  if (state is NewsStateSuccess) {
                    return RefreshIndicator(
                      onRefresh: onRefresh,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: state.data.hasReachedEnd
                            ? state.data.news.length
                            : state.data.news.length + 1,
                        itemBuilder: (ctx, index) =>
                            index >= state.data.news.length
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
                                  ),
                      ),
                    );
                  }

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
