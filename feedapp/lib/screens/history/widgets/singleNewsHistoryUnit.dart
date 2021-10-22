import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/components/common/centerLoadingWidget.dart';
import 'package:stolk/components/common/noConnection.dart';
import 'package:stolk/logic/blocs/newsHistoryBloc/newsHistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/screens/history/widgets/singleActivity.dart';
import 'package:timeline_tile/timeline_tile.dart';

const SINGLE_NEWS_HEIGHT = 300.0;

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
    initalFetch();
    _scrollController = ScrollController();
    _scrollController.addListener(
      () {
        // Debounce
        if (_timer != null && _timer!.isActive) _timer!.cancel();
        _timer = Timer(
          Duration(milliseconds: 50),
          () {
            if (_scrollController.hasClients) {
              final maxScroll = _scrollController.position.maxScrollExtent;
              final currentScroll = _scrollController.position.pixels;
              if (maxScroll - currentScroll <= SINGLE_NEWS_HEIGHT * 3) {
                context.read<NewsHistoryBloc>().add(
                      FetchNextHistoryNewsEvent(
                        filterBy: widget.filterBy,
                      ),
                    );
              }
            }
          },
        );
      },
    );
  }

  void initalFetch() {
    context.read<NewsHistoryBloc>().add(
          FetchHistoryNewsEvent(
            filterBy: widget.filterBy,
          ),
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
      child: BlocBuilder<NewsHistoryBloc, NewsHistoryState>(
        builder: (ctx, state) {
          if (state is NewsHistoryStateLoading) return CenterLoadingWidget();
          if (state is NewsHistoryStateWithData) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              itemCount: state.data.hasReachedEnd
                  ? state.data.news.length
                  : state.data.news.length + 1,
              itemBuilder: (ctx, index) => index >= state.data.news.length
                  ? Container(
                      height: 70,
                      child: Center(
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 8,
                        ),
                      ),
                    )
                  : TimelineTile(
                      isFirst: index == 0,
                      isLast: index == state.data.news.length - 1,
                      endChild: SingleHistoryActivity(
                        news: state.data.news[index],
                      ),
                    ),
            );
          }
          if (state is NewsHistoryStateNoData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assessment,
                  color: Theme.of(context).colorScheme.primary,
                  size: 100,
                ),
                Text(
                  tr("news.no_news"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }
          if (state is NewsHistoryStateError) {
            return NoConnectionWidget();
          }
          return Container();
        },
      ),
    );
  }
}
