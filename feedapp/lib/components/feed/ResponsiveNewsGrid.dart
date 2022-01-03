import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/components/ads/rectangleBanner.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/screens/feed/widgets/singleNews.dart';
import 'package:stolk/utils/ads/adPlaceGenerator.dart';
import 'package:stolk/utils/ads/constants.dart';
import 'package:stolk/utils/ui/constants.dart';

class ResponsiveNewsGrid extends StatefulWidget {
  final ScrollController scrollController;
  final NewsStateWithData state;
  final SliverAppBar? appBar;
  final void Function() forceFetchNext;
  final bool includeAds;
  const ResponsiveNewsGrid({
    Key? key,
    this.appBar,
    this.includeAds = false,
    required this.scrollController,
    required this.state,
    required this.forceFetchNext,
  }) : super(key: key);

  @override
  State<ResponsiveNewsGrid> createState() => _ResponsiveNewsGridState();
}

class _ResponsiveNewsGridState extends State<ResponsiveNewsGrid> {
  final adPlaces = getRandomAdPlaces(5);

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
    if (widget.includeAds == true && adPlaces.contains(index)) {
      return RectangleBannerAd(
        unitID: getUnitID(
          AdPlacements.newsGrid,
        ),
      );
    }

    int indexWithOffset = index;

    if (widget.includeAds == true) {
      for (int i in adPlaces) {
        if (i < index) {
          indexWithOffset--;
        }
      }
    }

    return SingleNewsView(
      key: Key(
        widget.state.data.news[indexWithOffset].id.toString(),
      ),
      feed: widget.state.data.news[indexWithOffset],
      index: indexWithOffset,
    );
  }

  Widget? loadingBuilder() {
    if (widget.state.data.hasReachedEnd == false) {
      if (widget.state is NewsNextFetchError) {
        return SizedBox(
          height: 50,
          child: Center(
            child: ElevatedButton(
              onPressed: widget.forceFetchNext,
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
    int childCount = widget.state.data.news.length;
    if (widget.includeAds == true) {
      for (int i in adPlaces) {
        if (i < widget.state.data.news.length) {
          childCount++;
        }
      }
    }
    return CustomScrollView(
      controller: widget.scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        if (widget.appBar != null) widget.appBar!,
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverGrid(
            gridDelegate: delegateBuilder(context),
            delegate: SliverChildBuilderDelegate(
              itemBuilder,
              childCount: childCount,
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
