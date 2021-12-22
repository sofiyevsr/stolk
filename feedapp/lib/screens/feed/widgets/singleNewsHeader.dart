import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/components/common/dialogs/reportDialog.dart';
import 'package:stolk/components/common/scaleButton.dart';
import 'package:stolk/components/common/sourceLogo.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/screens/feed/widgets/sourceNews.dart';
import 'package:stolk/utils/@types/response/allNews.dart';
import 'package:stolk/utils/common.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import 'package:stolk/utils/services/server/reportService.dart';
import 'package:stolk/utils/services/server/sourceService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/utils/ui/constants.dart';

final sources = SourceService();
const _iconSize = 30.0;

class SingleNewsHeader extends StatefulWidget {
  final SingleNews feed;
  final int index;
  const SingleNewsHeader({Key? key, required this.feed, required this.index})
      : super(key: key);

  @override
  _SingleNewsHeaderState createState() => _SingleNewsHeaderState();
}

class _SingleNewsHeaderState extends State<SingleNewsHeader> {
  final reportApi = ReportService();
  bool _isRequestOn = false;

  void onFinish() async {
    final news = context.read<NewsBloc>();
    setState(() {
      _isRequestOn = true;
    });
    try {
      if (widget.feed.followID == null) {
        await sources.follow(widget.feed.sourceID);
        news.add(
          NewsActionEvent(index: widget.index, type: NewsActionType.FOLLOW),
        );
      } else {
        await sources.unfollow(widget.feed.sourceID);
        news.add(
          NewsActionEvent(index: widget.index, type: NewsActionType.UNFOLLOW),
        );
      }
      setState(() {
        _isRequestOn = false;
      });
    } catch (e) {
      setState(() {
        _isRequestOn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: HEADER_HEIGHT,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              NavigationService.push(
                BlocProvider<NewsBloc>(
                  create: (ctx) => NewsBloc(),
                  child: SourceNews(
                    sourceID: widget.feed.sourceID,
                    sourceName: widget.feed.sourceName,
                    logoSuffix: widget.feed.sourceLogoSuffix,
                  ),
                ),
                RouteNames.SOURCE_NEWS_FEED,
              );
            },
            child: Row(
              children: [
                SizedBox(
                  height: 65,
                  width: 65,
                  child: SourceLogo(
                    isCircle: true,
                    logoSuffix: widget.feed.sourceLogoSuffix,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      this.widget.feed.sourceName,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headline6?.copyWith(fontSize: 18),
                    ),
                    Text(
                      convertDiffTime(this.widget.feed.publishedDate, context),
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.subtitle2?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Tooltip(
                message: tr("tooltips.follow"),
                child: ScaleButton(
                  disabled: _isRequestOn,
                  child: widget.feed.followID != null
                      ? Icon(
                          Icons.done_all,
                          size: _iconSize,
                        )
                      : Icon(
                          Icons.add,
                          size: _iconSize,
                        ),
                  onFinish: onFinish,
                ),
              ),
              PopupMenuButton<String>(
                offset: const Offset(0, 40),
                iconSize: _iconSize,
                onSelected: (v) async {
                  try {
                    authorize();
                    await showDialog(
                      context: context,
                      builder: (ctx) => ReportDialog(
                        onConfirmed: (String message) {
                          return reportApi.newsReport(message, widget.feed.id);
                        },
                      ),
                    );
                  } catch (_) {}
                },
                itemBuilder: (entry) {
                  return [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(Icons.report, color: Colors.red),
                          ),
                          Text(
                            tr("report.menu"),
                          ),
                        ],
                      ),
                      value: "report",
                    ),
                  ];
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
