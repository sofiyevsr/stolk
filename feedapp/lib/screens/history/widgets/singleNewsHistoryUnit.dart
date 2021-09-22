import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/components/common/centerLoadingWidget.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/screens/feed/widgets/singleNews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                context.read<NewsBloc>().add(
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
          if (state is NewsStateWithData) {
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
                  : SingleNewsView(
                      key: Key(
                        state.data.news[index].id.toString(),
                      ),
                      feed: state.data.news[index],
                      index: index,
                    ),
            );
          }
          if (state is NewsStateNoData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assessment,
                  color: Theme.of(context).colorScheme.primary,
                  size: 100,
                ),
                //TODO try following more sources
                Text(
                  tr("missing"),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }
          if (state is NewsStateError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red[700],
                    size: 100,
                  ),
                  //TODO
                  Text(
                    tr("missing"),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
