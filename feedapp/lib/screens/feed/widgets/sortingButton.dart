import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';

typedef OnSortChange = void Function(int);

const tiles = [
  {
    "value": NewsSortBy.POPULAR,
    "text": "popular",
    "icon": Icon(Icons.star_rate_sharp)
  },
  {
    "value": NewsSortBy.LATEST,
    "text": "latest",
    "icon": Icon(Icons.new_releases_sharp)
  },
  {
    "value": NewsSortBy.MOST_LIKED,
    "text": "most_liked",
    "icon": Icon(Icons.favorite_sharp)
  },
  {
    "value": NewsSortBy.MOST_READ,
    "text": "most_read",
    "icon": Icon(Icons.chrome_reader_mode_sharp)
  },
];

class FeedSortingButton extends StatelessWidget {
  final OnSortChange callback;
  const FeedSortingButton({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box("settings").listenable(keys: ["sortBy"]),
        builder: (context, Box gBox, _) {
          final sortBy = gBox.get("sortBy", defaultValue: 0);
          return TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return IconTheme(
                    data: IconThemeData(size: 32),
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
                              e["text"] as String,
                            ),
                            leading: e["icon"] as Icon,
                            selected: e["value"] == sortBy,
                            onTap: () async {
                              await gBox.put("sortBy", e["value"]);
                              callback(e["value"] as int);
                              NavigationService.pop();
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
                ),
                Icon(Icons.expand_more),
              ],
            ),
          );
        });
  }
}
