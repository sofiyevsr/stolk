import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/components/common/sourceLogo.dart';
import 'package:stolk/logic/blocs/sourcesBloc/sources.dart';
import 'package:stolk/screens/feed/sourceNews.dart';
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                NavigationService.push(
                  SourceNewsScreen(
                    sourceID: item.id,
                    sourceName: item.name,
                    logoSuffix: item.logoSuffix,
                  ),
                  RouteNames.SOURCE_NEWS_FEED,
                );
              },
              child: Column(
                children: [
                  Expanded(
                    child: SourceLogo(
                      logoSuffix: item.logoSuffix,
                      isCircle: true,
                    ),
                  ),
                  AutoSizeText(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: item.isRequestOn ? null : () => onFinish(context),
              child: AutoSizeText(
                item.followID == null
                    ? tr("commons.follow")
                    : tr("commons.following"),
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
