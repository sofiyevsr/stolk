import 'dart:async';

import 'package:feedapp/logic/blocs/newsBloc/utils/NewsBloc.dart';
import 'package:feedapp/screens/feed/widgets/categoryList.dart';
import 'package:feedapp/screens/feed/widgets/singleNews.dart';
import 'package:feedapp/screens/feed/widgets/allNewsShimmer.dart';
import 'package:feedapp/utils/debounce.dart';
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
  bool showFab = false;

  Debounce _debouncer = Debounce(
    duration: const Duration(milliseconds: 75),
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final currentScroll = _scrollController.position.pixels;

      if (currentScroll < 100 && showFab == true) {
        setState(() {
          showFab = false;
        });
      }
      if (currentScroll > 100 && showFab == false) {
        setState(() {
          showFab = true;
        });
      }
    });
    _scrollController.addListener(
      () => _debouncer.run(
        () {
          final maxScroll = _scrollController.position.maxScrollExtent;
          final currentScroll = _scrollController.position.pixels;

          if (maxScroll - currentScroll <= SINGLE_NEWS_HEIGHT * 3) {
            context.read<NewsBloc>().add(
                  FetchNextNewsEvent(
                    category: _currentCategory,
                    sourceID: null,
                    filterBy: null,
                  ),
                );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void forceFetchNext() {
    BlocProvider.of<NewsBloc>(context).add(
      FetchNextNewsEvent(
        category: _currentCategory,
        sourceID: null,
        filterBy: null,
        force: true,
      ),
    );
  }

  Future<void> onRefresh() async {
    try {
      final data = await service.getAllNews(
          pubDate: null, category: _currentCategory, filterBy: null);
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
      FetchNewsEvent(category: id, sourceID: null, filterBy: null),
    );
    setState(() {
      _currentCategory = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                    if (state is NewsStateLoading) return AllNewsShimmer();
                    if (state is NewsStateWithData) {
                      return RefreshIndicator(
                        onRefresh: onRefresh,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          controller: _scrollController,
                          itemCount: state.data.hasReachedEnd
                              ? state.data.news.length
                              : state.data.news.length + 1,
                          itemBuilder: (ctx, index) => index >=
                                  state.data.news.length
                              ? state is NewsNextFetchError
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
                                        child:
                                            CircularProgressIndicator.adaptive(
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
        if (showFab)
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(onPressed: () {
              _scrollController.animateTo(
                0,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
            }),
          ),
      ],
    );
  }
}
