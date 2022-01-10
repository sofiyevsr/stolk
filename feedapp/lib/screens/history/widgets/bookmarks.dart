import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:stolk/components/common/centerLoadingWidget.dart';
import 'package:stolk/components/common/lottieLoader.dart';
import 'package:stolk/components/common/noConnection.dart';
import 'package:stolk/components/feed/ResponsiveNewsGrid.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/utils/ui/constants.dart';

class Bookmarks extends StatefulWidget {
  const Bookmarks({
    Key? key,
  }) : super(key: key);

  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  late ScrollController _scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    initalFetch();
    _scrollController.addListener(
      () {
        // Debounce
        if (_timer != null && _timer!.isActive) _timer!.cancel();
        _timer = Timer(
          const Duration(milliseconds: 50),
          () {
            if (_scrollController.hasClients) {
              final maxScroll = _scrollController.position.maxScrollExtent;
              final currentScroll = _scrollController.position.pixels;
              if (maxScroll - currentScroll <= SINGLE_NEWS_HEIGHT * 4) {
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
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (ctx, state) {
        if (state is NewsStateLoading) return const CenterLoadingWidget();
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
              const LottieLoader(
                asset: "assets/lottie/bookmark.json",
                size: Size(200, 200),
                repeat: false,
              ),
              Text(
                tr("news.no_bookmarks"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }
        if (state is NewsStateError) {
          return const NoConnectionWidget();
        }
        return Container();
      },
    );
  }
}
