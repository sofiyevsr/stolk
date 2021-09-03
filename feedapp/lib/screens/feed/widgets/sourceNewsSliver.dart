import 'package:stolk/components/common/centerLoadingWidget.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/utils/debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'singleNews.dart';

const SINGLE_NEWS_HEIGHT = 300;

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
    widget.scrollController.addListener(
      () {
        // Debounce
        _debouncer.run(
          () {
            final maxScroll = widget.scrollController.position.maxScrollExtent;
            final currentScroll = widget.scrollController.position.pixels;
            if (maxScroll - currentScroll <= SINGLE_NEWS_HEIGHT * 3) {
              context.read<NewsBloc>().add(
                    FetchNextNewsEvent(
                      category: null,
                      sourceID: widget.sourceID,
                    ),
                  );
            }
          },
        );
      },
    );
  }

  void forceFetchNext() {
    BlocProvider.of<NewsBloc>(context).add(
      FetchNextNewsEvent(
        category: null,
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
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, index) => index >= state.data.news.length
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
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 8,
                            ),
                          ),
                        )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: SingleNewsView(
                        key: Key(
                          state.data.news[index].id.toString(),
                        ),
                        feed: state.data.news[index],
                        index: index,
                      ),
                    ),
              childCount: state.data.hasReachedEnd
                  ? state.data.news.length
                  : state.data.news.length + 1,
            ),
          );
        }

        if (state is NewsStateNoData) {}
        if (state is NewsStateError) {}
        return SliverFillRemaining(
          child: Container(),
        );
      },
    );
  }
}
