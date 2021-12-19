import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/screens/feed/widgets/singleNews.dart';
import 'package:stolk/utils/ui/constants.dart';

class ResponsiveNewsGrid extends StatelessWidget {
  final ScrollController? scrollController;
  final NewsStateWithData state;
  final void Function() forceFetchNext;
  final bool sliver;
  const ResponsiveNewsGrid({
    Key? key,
    required this.state,
    required this.forceFetchNext,
    this.scrollController,
    this.sliver = false,
  })  : assert(
          sliver == false || (sliver == true && scrollController == null),
        ),
        super(key: key);

  SliverStaggeredGridDelegate delegateBuilder(BuildContext context) {
    final media = MediaQuery.of(context);
    final crossCount =
        (media.size.width / SINGLE_NEWS_SIZE).clamp(1, 3).toInt();
    return SliverStaggeredGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossCount,
      crossAxisSpacing: 20,
      staggeredTileBuilder: (i) => i >= state.data.news.length
          ? StaggeredTile.fit(3)
          : StaggeredTile.fit(1),
    );
  }

  Widget itemBuilder(BuildContext ctx, int index) {
    if (index >= state.data.news.length) {
      if (state is NewsNextFetchError)
        return Container(
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
      return Container(
        height: 50,
        child: Center(
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 8,
          ),
        ),
      );
    }
    return SingleNewsView(
      key: Key(
        state.data.news[index].id.toString(),
      ),
      feed: state.data.news[index],
      index: index,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (sliver == true)
      return SliverStaggeredGrid(
        gridDelegate: delegateBuilder(context),
        delegate: SliverChildBuilderDelegate(
          itemBuilder,
          childCount: state.data.hasReachedEnd
              ? state.data.news.length
              : state.data.news.length + 1,
        ),
      );

    return StaggeredGridView.builder(
      gridDelegate: delegateBuilder(context),
      physics: BouncingScrollPhysics(),
      controller: scrollController,
      itemCount: state.data.hasReachedEnd
          ? state.data.news.length
          : state.data.news.length + 1,
      itemBuilder: itemBuilder,
    );
  }
}
