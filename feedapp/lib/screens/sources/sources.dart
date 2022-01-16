import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/components/common/centerLoadingWidget.dart';
import 'package:stolk/components/common/customBottomSheet.dart';
import 'package:stolk/components/common/noConnection.dart';
import 'package:stolk/logic/blocs/sourcesBloc/sources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';

import 'widgets/singleSourceView.dart';

class SourcesPage extends StatefulWidget {
  const SourcesPage({Key? key}) : super(key: key);

  @override
  _SourcesPageState createState() => _SourcesPageState();
}

class _SourcesPageState extends State<SourcesPage> {
  // Default is -1 which means all
  int? _currentLangID;
  String? _search;

  @override
  void initState() {
    super.initState();
    fetchSources();
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
        _SourceHeader(
          onFilter: (s) {
            setState(() {
              _currentLangID = s;
            });
          },
          onSearch: (s) {
            setState(() {
              _search = s;
            });
          },
          currentLangID: _currentLangID,
        ),
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
      ],
    );
  }
}

class _SourceHeader extends StatelessWidget {
  final Function(String term) onSearch;
  final void Function(int? langID) onFilter;
  final int? currentLangID;
  const _SourceHeader({
    required this.onFilter,
    required this.onSearch,
    required this.currentLangID,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    child: TextField(
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: "test",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(maxHeight: 48),
                      ),
                      onChanged: onSearch,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      builder: (ctx) => CustomBottomSheet<int>(
                        onSubmit: (v) {},
                        options: [
                          CustomBottomSheetOption(
                            value: -1,
                            title: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                      "assets/flags/az.png",
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
                        defaultValue: -1,
                        title: "Test",
                      ),
                    );
                  },
                  child: Text("show"),
                )
                // DropdownButton<int?>(
                //   value: currentLangID,
                //   hint: Text(
                //     tr("sources.search"),
                //   ),
                //   onChanged: onFilter,
                //   items: [
                //     DropdownMenuItem<int>(
                //       value: null,
                //       child: Text(
                //         tr("sources.all"),
                //       ),
                //     ),
                //     ...LANGS.entries.map<DropdownMenuItem<int>>(
                //       (e) => DropdownMenuItem(
                //         value: e.key,
                //         child: CircleAvatar(
                //           backgroundImage: AssetImage(
                //             'assets/flags/${e.value}.png',
                //           ),
                //           radius: 10,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
