import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/components/common/sourceLogo.dart';
import 'package:stolk/screens/feed/sourceFeed.dart';
import 'package:stolk/utils/@types/response/allSources.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import 'package:stolk/utils/services/server/sourceService.dart';
import 'package:flutter/material.dart';

final service = SourceService();

class SingleSourceView extends StatefulWidget {
  final SingleSource item;
  const SingleSourceView({Key? key, required this.item}) : super(key: key);

  @override
  _SingleSourceViewState createState() => _SingleSourceViewState();
}

class _SingleSourceViewState extends State<SingleSourceView> {
  late bool _isFollowing;
  bool _isRequestOn = false;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.item.followID != null;
  }

  void onFinish() async {
    setState(() {
      _isRequestOn = true;
    });
    try {
      if (_isFollowing == true) {
        await service.unfollow(widget.item.id);
      } else {
        await service.follow(widget.item.id);
      }
      setState(() {
        _isRequestOn = false;
        _isFollowing = !_isFollowing;
      });
    } catch (e) {
      setState(() {
        _isRequestOn = false;
      });
    }
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
                    sourceID: widget.item.id,
                    sourceName: widget.item.name,
                    logoSuffix: widget.item.logoSuffix,
                  ),
                  RouteNames.SOURCE_NEWS_FEED,
                );
              },
              child: Column(
                children: [
                  Text(
                    widget.item.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: Container(
                      child: Center(
                        child: SourceLogo(
                          logoSuffix: widget.item.logoSuffix,
                          isCircle: true,
                          radius: 100,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _isRequestOn ? null : onFinish,
            child: Text(
              _isFollowing == true
                  ? tr("commons.following")
                  : tr("commons.follow"),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
