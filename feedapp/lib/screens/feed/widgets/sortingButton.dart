import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';

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
  {"value": 1, "text": "daily", "icon": Icon(Icons.view_day_sharp)},
  {"value": 7, "text": "weekly", "icon": Icon(Icons.view_week_sharp)},
  {
    "value": 31,
    "text": "monthly",
    "icon": Icon(Icons.calendar_view_month_sharp)
  },
];

/// The [callback] will be called with [sortBy], [period] after persisting choices
class FeedSortingButton extends StatelessWidget {
  final OnSortChange callback;
  const FeedSortingButton({Key? key, required this.callback}) : super(key: key);

  void buildPeriod(
    BuildContext context, {
    required int currentPeriod,
    required int selectedSortBy,
    required bool hasSortByChanged,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(10),
              child: Text(
                tr("sort_by.period.title"),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Divider(),
            ...periodTiles.map(
              (e) => ListTile(
                title: Text(
                  tr("sort_by.period.${e["text"]}"),
                ),
                leading: e["icon"] as Icon,
                selected:
                    hasSortByChanged == true && e["value"] == currentPeriod,
                trailing:
                    hasSortByChanged == true && e["value"] == currentPeriod
                        ? Icon(Icons.done)
                        : null,
                onTap: () async {
                  final gBox = Hive.box("settings");
                  gBox.putAll({
                    "sortBy": selectedSortBy,
                    "period": e["value"],
                  });
                  NavigationService.pop();
                  callback(selectedSortBy, e["value"] as int);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box("settings").listenable(
          keys: ["sortBy", "period"],
        ),
        builder: (context, Box gBox, _) {
          final sortBy = gBox.get("sortBy", defaultValue: 0);
          final period =
              gBox.get("period", defaultValue: HiveDefaultValues.PERIOD);
          return TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return IconTheme(
                    data: Theme.of(ctx).iconTheme.copyWith(
                          size: 28,
                        ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            tr("sort_by.title"),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Divider(),
                        ...tiles.map(
                          (e) => ListTile(
                            title: Text(
                              tr("sort_by.${e["text"]}"),
                            ),
                            leading: e["icon"] as Icon,
                            selected: e["value"] == sortBy,
                            onTap: () async {
                              NavigationService.pop();
                              buildPeriod(
                                context,
                                currentPeriod: period,
                                selectedSortBy: e["value"] as int,
                                hasSortByChanged: e["value"] as int == sortBy,
                              );
                            },
                            trailing:
                                e["value"] == sortBy ? Icon(Icons.done) : null,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tr("sort_by.${sortByToString(sortBy)}"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Icon(Icons.expand_more),
              ],
            ),
          );
        });
  }
}
