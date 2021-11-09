import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:stolk/components/common/heightAnimationOnScroll.dart';
import 'package:stolk/components/common/noConnection.dart';
import 'package:stolk/components/common/noNews.dart';
import 'package:stolk/logic/blocs/newsBloc/utils/NewsBloc.dart';
import 'package:stolk/screens/feed/widgets/categoryList.dart';
import 'package:stolk/screens/feed/widgets/singleNews.dart';
import 'package:stolk/screens/feed/widgets/allNewsShimmer.dart';
import 'package:stolk/screens/feed/widgets/sortingButton.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/debounce.dart';
import 'package:stolk/utils/services/server/newsService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const SINGLE_NEWS_HEIGHT = 300.0;

final service = NewsService();

class AllNewsScreen extends StatefulWidget {
  const AllNewsScreen({Key? key}) : super(key: key);

  @override
  _AllNewsScreenState createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  int? _currentSortBy;
  int? _currentPeriod;
  ScrollController _scrollController = ScrollController();
  int _currentCategory = 0;
  bool showFab = false;

  Debounce _debouncer = Debounce(
    duration: const Duration(milliseconds: 75),
  );

  @override
  void initState() {
    super.initState();
    initialFetch();
    _scrollController.addListener(() {
      final currentScroll = _scrollController.position.pixels;

      if (currentScroll < 100 && showFab == true) {
        if (mounted)
          setState(() {
            showFab = false;
          });
      }
      if (currentScroll > 100 && showFab == false) {
        if (mounted)
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
                    sourceID: null,
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

  void initialFetch() {
    final box = Hive.box("settings");
    _currentSortBy = box.get("sortBy", defaultValue: 0);
    _currentPeriod = box.get("period", defaultValue: HiveDefaultValues.PERIOD);
    context.read<NewsBloc>().add(
          FetchNewsEvent(
            category: null,
            sourceID: null,
            sortBy: _currentSortBy,
            period: _currentPeriod,
          ),
        );
  }

  void forceFetchNext() {
    context.read<NewsBloc>().add(
          FetchNextNewsEvent(
            sourceID: null,
            force: true,
          ),
        );
  }

  Future<void> onRefresh() async {
    try {
      final data = await service.getAllNews(
        pubDate: null,
        category: _currentCategory,
        sortBy: _currentSortBy,
        period: _currentPeriod,
      );
      BlocProvider.of<NewsBloc>(context).add(
        RefreshNewsEvent(
          data: data,
          sortBy: _currentSortBy,
          category: _currentCategory,
          period: _currentPeriod,
        ),
      );
    } catch (e) {}
  }

  void _changeCategory(int id) {
    if (id == _currentCategory) {
      return;
    }
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(
        0,
      );
    }
    final bloc = context.read<NewsBloc>();
    bloc.add(
      FetchNewsEvent(
        category: id,
        sourceID: null,
        sortBy: _currentSortBy,
        period: _currentPeriod,
      ),
    );
    if (mounted)
      setState(() {
        _currentCategory = id;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            AnimationOnScroll(
              scrollController: _scrollController,
              maxHeight: 100,
              child: CategoryList(
                current: _currentCategory,
                changeCategory: _changeCategory,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: FeedSortingButton(
                callback: (sortBy, period) {
                  this._currentSortBy = sortBy;
                  this._currentPeriod = period;
                  context.read<NewsBloc>().add(
                        FetchNewsEvent(
                          category: _currentCategory,
                          sourceID: null,
                          sortBy: _currentSortBy,
                          period: _currentPeriod,
                        ),
                      );
                },
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
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
                                  ? Center(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        height: 50,
                                        child: ElevatedButton.icon(
                                          onPressed: forceFetchNext,
                                          icon: Icon(Icons.refresh),
                                          label: Text(
                                            tr("buttons.retry_request"),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 50,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
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

                    if (state is NewsStateNoData) {
                      return NoNewsWidget();
                    }
                    if (state is NewsStateError) {
                      return NoConnectionWidget(
                        onRetry: initialFetch,
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ],
        ),
        if (showFab)
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              tooltip: tr("tooltips.back_to_top"),
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                );
              },
              child: Icon(Icons.north_sharp),
            ),
          ),
      ],
    );
  }
}
