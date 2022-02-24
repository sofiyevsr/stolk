import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stolk/components/common/customBottomSheet.dart';
import 'package:stolk/utils/constants.dart';

typedef OnSortChange = void Function(int, int);

const tiles = [
  {
    "value": NewsSortBy.POPULAR,
    "text": "popular",
    "icon": Icon(Icons.trending_up_sharp)
  },
  {"value": NewsSortBy.LATEST, "text": "latest", "icon": Icon(Icons.today)},
  {
    "value": NewsSortBy.MOST_LIKED,
    "text": "most_liked",
    "icon": Icon(Icons.favorite_sharp)
  },
  {
    "value": NewsSortBy.MOST_READ,
    "text": "most_read",
    "icon": Icon(Icons.book_sharp)
  },
];

const periodTiles = [
  {"value": 1, "text": "daily", "icon": Icon(Icons.wb_sunny_outlined)},
  {"value": 7, "text": "weekly", "icon": Icon(Icons.view_week_sharp)},
  {"value": 31, "text": "monthly", "icon": Icon(Icons.date_range_outlined)},
];

/// The [callback] will be called with [sortBy], [period] after persisting choices
class FeedSortingButton extends StatelessWidget {
  final OnSortChange callback;
  final gBox = Hive.box("settings");
  FeedSortingButton({Key? key, required this.callback}) : super(key: key);

  void buildPeriod(
    BuildContext context, {
    required int selectedSortBy,
    required int period,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (ctx) {
        return CustomBottomSheet<int?>(
          onSubmit: (period) {
            gBox.putAll({
              "sortBy": selectedSortBy,
              "period": period!,
            });
            callback(selectedSortBy, period);
          },
          options: periodTiles
              .map<CustomBottomSheetOption<int>>(
                (e) => CustomBottomSheetOption(
                  value: e["value"] as int,
                  title: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: e["icon"] as Icon,
                      ),
                      Text(
                        tr("sort_by.period.${e["text"]}"),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          defaultValue: period,
          title: tr("sort_by.period.title"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: gBox.listenable(keys: ["sortBy", "period"]),
        builder: (context, Box box, child) {
          final sortBy = gBox.get("sortBy", defaultValue: 0);
          final period =
              gBox.get("period", defaultValue: HiveDefaultValues.PERIOD);
          return TextButton(
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
                  hasNext: true,
                  onSubmit: (sortBy) {
                    buildPeriod(
                      context,
                      selectedSortBy: sortBy!,
                      period: period,
                    );
                  },
                  options: tiles
                      .map<CustomBottomSheetOption<int>>(
                        (e) => CustomBottomSheetOption(
                          value: e["value"] as int,
                          title: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: e["icon"] as Icon,
                              ),
                              Text(
                                tr("sort_by.${e["text"]}"),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  defaultValue: sortBy,
                  title: tr("sort_by.title"),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tr("sort_by.${sortByToString(sortBy)}"),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Icon(Icons.expand_more),
              ],
            ),
          );
        });
  }
}
