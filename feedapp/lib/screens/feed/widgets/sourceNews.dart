import 'package:auto_size_text/auto_size_text.dart';
import 'package:stolk/components/common/centerLoadingWidget.dart';
import 'package:stolk/components/common/noConnection.dart';
import 'package:stolk/components/common/noNews.dart';
import 'package:stolk/components/common/sourceLogo.dart';
import 'package:stolk/components/feed/ResponsiveNewsGrid.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/utils/debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/utils/ui/constants.dart';

class SourceNews extends StatefulWidget {
  final int sourceID;
  final String sourceName;
  final String logoSuffix;
  const SourceNews({
    Key? key,
    required this.sourceID,
    required this.sourceName,
    required this.logoSuffix,
  }) : super(key: key);

  @override
  _SourceNewsState createState() => _SourceNewsState();
}

class _SourceNewsState extends State<SourceNews> {
  late ScrollController scrollController = ScrollController();
  Debounce debouncer = Debounce(
    duration: const Duration(milliseconds: 75),
  );

  @override
  void initState() {
    super.initState();
    fetchNews();
    scrollController.addListener(
      () {
        // Debounce
        debouncer.run(
          () {
            final maxScroll = scrollController.position.maxScrollExtent;
            final currentScroll = scrollController.position.pixels;
            if (maxScroll - currentScroll <= SINGLE_NEWS_HEIGHT * 4) {
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
    debouncer.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (ctx, state) {
            if (state is NewsStateLoading) return const CenterLoadingWidget();
            if (state is NewsStateWithData) {
              final media = MediaQuery.of(context).size;
              final expandedHeight =
                  media.width > media.height ? media.height : media.width;

              return ResponsiveNewsGrid(
                appBar: SliverAppBar(
                  pinned: true,
                  expandedHeight: expandedHeight,
                  elevation: 2,
                  title: AutoSizeText(
                    widget.sourceName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: Padding(
                      padding: const EdgeInsets.only(
                        top: kToolbarHeight,
                      ),
                      child: SourceLogo(
                        logoSuffix: widget.logoSuffix,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                state: state,
                forceFetchNext: forceFetchNext,
                scrollController: scrollController,
              );
            }
            if (state is NewsStateNoData) {
              return const NoNewsWidget();
            }
            if (state is NewsStateError) {
              return NoConnectionWidget(onRetry: fetchNews);
            }
            return Container();
          },
        ),
      ),
    );
  }
}
