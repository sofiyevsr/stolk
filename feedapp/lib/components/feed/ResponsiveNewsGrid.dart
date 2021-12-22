import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/screens/feed/widgets/singleNews.dart';
import 'package:stolk/utils/ui/constants.dart';

class ResponsiveNewsGrid extends StatelessWidget {
  final ScrollController scrollController;
  final NewsStateWithData state;
  final SliverAppBar? appBar;
  final void Function() forceFetchNext;
  const ResponsiveNewsGrid({
    Key? key,
    this.appBar,
    required this.scrollController,
    required this.state,
    required this.forceFetchNext,
  }) : super(key: key);

  SliverGridDelegateWithFixedCrossAxisCount delegateBuilder(
    BuildContext context,
  ) {
    final media = MediaQuery.of(context);
    final crossCount =
        (media.size.width / SINGLE_NEWS_WIDTH).clamp(1, 3).toInt();
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossCount,
      crossAxisSpacing: 20,
      mainAxisExtent: SINGLE_NEWS_HEIGHT,
    );
  }

  Widget itemBuilder(BuildContext ctx, int index) {
    return SingleNewsView(
      key: Key(
        state.data.news[index].id.toString(),
      ),
      feed: state.data.news[index],
      index: index,
    );
  }

  Widget? loadingBuilder() {
    if (state.data.hasReachedEnd == false) {
      if (state is NewsNextFetchError) {
        return SizedBox(
          height: 50,
          child: Center(
            child: ElevatedButton(
              onPressed: forceFetchNext,
              child: Text(
                tr("buttons.retry_request"),
              ),
            ),
          ),
        );
      }
      return const SizedBox(
        height: 50,
        child: Center(
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 8,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        if (appBar != null) appBar!,
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverGrid(
            gridDelegate: delegateBuilder(context),
            delegate: SliverChildBuilderDelegate(
              itemBuilder,
              childCount: state.data.news.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: loadingBuilder(),
          ),
        ),
      ],
    );
  }
}
