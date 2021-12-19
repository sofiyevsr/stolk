import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:stolk/components/common/centerLoadingWidget.dart';
import 'package:stolk/components/common/noConnection.dart';
import 'package:stolk/components/feed/ResponsiveNewsGrid.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/screens/feed/widgets/singleNews.dart';
import 'package:stolk/utils/ui/constants.dart';

class SingleNewsHistoryUnit extends StatefulWidget {
  const SingleNewsHistoryUnit({
    Key? key,
  }) : super(key: key);

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
              if (maxScroll - currentScroll <= SINGLE_NEWS_SIZE * 4) {
                context.read<NewsBloc>().add(
                      FetchNextBookmarks(),
                    );
              }
            }
          },
        );
      },
    );
  }

  void initalFetch() {
    context.read<NewsBloc>().add(
          FetchBookmarks(),
        );
  }

  void forceFetchNext() {
    context.read<NewsBloc>().add(
          FetchNextBookmarks(
            force: true,
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
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: BlocBuilder<NewsBloc, NewsState>(
        builder: (ctx, state) {
          if (state is NewsStateLoading) return CenterLoadingWidget();
          if (state is NewsStateWithData) {
            return ResponsiveNewsGrid(
              state: state,
              forceFetchNext: forceFetchNext,
              scrollController: _scrollController,
            );
          }
          if (state is NewsStateNoData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/lottie/bookmark.json",
                ),
                Text(
                  tr("news.no_bookmarks"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }
          if (state is NewsStateError) {
            return NoConnectionWidget();
          }
          return Container();
        },
      ),
    );
  }
}
