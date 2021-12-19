import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stolk/components/common/centerLoadingWidget.dart';
import 'package:stolk/components/common/noConnection.dart';
import 'package:stolk/components/common/noNews.dart';
import 'package:stolk/components/feed/ResponsiveNewsGrid.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/utils/debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/utils/ui/constants.dart';

import 'singleNews.dart';

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
  Debounce _debouncer = Debounce(
    duration: const Duration(milliseconds: 75),
  );

  @override
  void initState() {
    super.initState();
    fetchNews();
    widget.scrollController.addListener(
      () {
        // Debounce
        _debouncer.run(
          () {
            final maxScroll = widget.scrollController.position.maxScrollExtent;
            final currentScroll = widget.scrollController.position.pixels;
            if (maxScroll - currentScroll <= SINGLE_NEWS_SIZE * 4) {
              context.read<NewsBloc>().add(
                    FetchNextNewsEvent(
                      sourceID: widget.sourceID,
                    ),
                  );
            }
          },
        );
      },
    );
  }

  void fetchNews() {
    context.read<NewsBloc>().add(
          FetchNewsEvent(
            category: null,
            sourceID: widget.sourceID,
            sortBy: null,
            period: null,
          ),
        );
  }

  void forceFetchNext() {
    BlocProvider.of<NewsBloc>(context).add(
      FetchNextNewsEvent(
        sourceID: widget.sourceID,
        force: true,
      ),
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
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
        if (state is NewsStateWithData) {
          return ResponsiveNewsGrid(
            state: state,
            forceFetchNext: forceFetchNext,
            sliver: true,
          );
        }
        if (state is NewsStateNoData) {
          return SliverFillRemaining(
            child: NoNewsWidget(),
          );
        }
        if (state is NewsStateError) {
          return SliverFillRemaining(
            child: NoConnectionWidget(onRetry: fetchNews),
          );
        }
        return SliverFillRemaining(
          child: Container(),
        );
      },
    );
  }
}
