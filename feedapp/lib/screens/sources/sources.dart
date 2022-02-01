import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/components/common/centerLoadingWidget.dart';
import 'package:stolk/components/common/customBottomSheet.dart';
import 'package:stolk/components/common/lottieLoader.dart';
import 'package:stolk/components/common/noConnection.dart';
import 'package:stolk/logic/blocs/sourcesBloc/sources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/debounce.dart';

import 'widgets/singleSourceView.dart';

class SourcesPage extends StatefulWidget {
  const SourcesPage({Key? key}) : super(key: key);

  @override
  _SourcesPageState createState() => _SourcesPageState();
}

class _SourcesPageState extends State<SourcesPage> {
  int? _currentLangID;
  String? _search;
  final Debounce _debouncer = Debounce(
    duration: const Duration(milliseconds: 100),
  );

  @override
  void initState() {
    super.initState();
    fetchSources();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  void fetchSources() {
    context.read<SourcesBloc>().add(
          FetchSourcesEvent(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final crossCount = (media.size.width / 170).clamp(2, 6).toInt();
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _SourceHeader(),
        SliverPersistentHeader(
          pinned: true,
          delegate: _PersistentSourceHeader(
            onFilter: (s) {
              setState(() {
                _currentLangID = s;
              });
            },
            onSearch: (s) => _debouncer.run(
              () {
                setState(() {
                  _search = s;
                });
              },
            ),
            currentLangID: _currentLangID,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          sliver:
              BlocBuilder<SourcesBloc, SourcesState>(builder: (context, state) {
            if (state is SourcesStateSuccess) {
              final sources = state.data.sources
                  .where(
                    (element) =>
                        (_currentLangID == null ||
                            element.langID == _currentLangID) &&
                        (_search == null ||
                            element.name.toLowerCase().contains(
                                  _search!.toLowerCase(),
                                )),
                  )
                  .toList();
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                ),
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => SingleSourceView(
                    item: sources[i],
                  ),
                  childCount: sources.length,
                ),
              );
            }
            return SliverFillRemaining(
              child: () {
                if (state is SourcesStateLoading) {
                  return const CenterLoadingWidget();
                }
                if (state is SourcesStateError)
                  return NoConnectionWidget(
                    onRetry: fetchSources,
                  );
                return Container();
              }(),
            );
          }),
        ),
      ],
    );
  }
}

class _SourceHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: AutoSizeText(
                      tr("sources.title"),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      minFontSize: 24,
                      maxLines: 2,
                    ),
                  ),
                  AutoSizeText(
                    tr("sources.description"),
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            const LottieLoader(
              asset: "assets/lottie/magnifying_glass.json",
              size: Size(
                120,
                120,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersistentSourceHeader extends SliverPersistentHeaderDelegate {
  final Function(String term) onSearch;
  final void Function(int? langID) onFilter;
  final int? currentLangID;
  const _PersistentSourceHeader({
    required this.onFilter,
    required this.onSearch,
    required this.currentLangID,
  });
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.all(12),
      height: 100,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: TextField(
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: tr("sources.search"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onChanged: onSearch,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 48),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                builder: (ctx) => CustomBottomSheet<int?>(
                  onSubmit: onFilter,
                  options: [
                    CustomBottomSheetOption(
                      value: null,
                      title: Row(
                        children: [
                          const Padding(
                            key: ValueKey(-1),
                            padding: EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                "assets/flags/earth.png",
                              ),
                            ),
                          ),
                          Text(
                            tr("sources.all"),
                          ),
                        ],
                      ),
                    ),
                    ...LANGS.entries.map<CustomBottomSheetOption<int>>(
                      (e) => CustomBottomSheetOption(
                        value: e.key,
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                  "assets/flags/${e.value}.png",
                                ),
                              ),
                            ),
                            Text(
                              tr("languages.${e.value}"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  defaultValue: currentLangID,
                  title: tr("sources.choose_lang"),
                ),
              );
            },
            child: const Icon(
              Icons.tune_outlined,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
