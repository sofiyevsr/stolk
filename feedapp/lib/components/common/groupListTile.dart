import 'package:partner_gainclub/components/common/iconBackground.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:partner_gainclub/components/common/tilesHeader.dart';

class GroupListTile extends StatelessWidget {
  final List<SingleTileInGroup> tiles;
  final String? title;
  const GroupListTile({Key? key, required this.tiles, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (this.title != null) TilesHeader(title: title!),
          ...tiles.map(
            (e) => Card(
              margin: const EdgeInsets.all(0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconBackground(
                          icon: e.icon,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          e.leadingText,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: DefaultTextStyle(
                            style:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ) ??
                                    TextStyle(),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            child: Center(child: e.trailing),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SingleTileInGroup {
  final IconData icon;
  final Widget trailing;
  final String leadingText;
  SingleTileInGroup(
      {required this.icon, required this.leadingText, required this.trailing});
}
