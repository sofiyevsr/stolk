import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/components/common/sourceLogo.dart';
import 'package:stolk/logic/blocs/sourcesBloc/sources.dart';
import 'package:stolk/screens/feed/sourceFeed.dart';
import 'package:stolk/utils/@types/response/allSources.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import 'package:stolk/utils/services/server/sourceService.dart';
import 'package:flutter/material.dart';

final service = SourceService();

class SingleSourceView extends StatelessWidget {
  final SingleSource item;
  const SingleSourceView({Key? key, required this.item}) : super(key: key);

  void onFinish(BuildContext context) async {
    final bloc = context.read<SourcesBloc>();
    bloc.add(
      ToggleSourceFollow(id: item.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                NavigationService.push(
                  SourceFeed(
                    sourceID: item.id,
                    sourceName: item.name,
                    logoSuffix: item.logoSuffix,
                  ),
                  RouteNames.SOURCE_NEWS_FEED,
                );
              },
              child: Column(
                children: [
                  Text(
                    item.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: SourceLogo(
                      logoSuffix: item.logoSuffix,
                      isCircle: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: item.isRequestOn ? null : () => onFinish(context),
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                (states) => Colors.blueAccent,
              ),
            ),
            child: Text(
              item.followID == null
                  ? tr("commons.follow")
                  : tr("commons.following"),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
