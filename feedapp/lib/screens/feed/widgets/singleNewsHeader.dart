import 'package:feedapp/components/common/scaleButton.dart';
import 'package:feedapp/utils/@types/response/allNews.dart';
import 'package:feedapp/utils/common.dart';
import 'package:feedapp/utils/services/server/sourceService.dart';
import 'package:flutter/material.dart';

final sources = SourceService();

class SingleNewsHeader extends StatefulWidget {
  final SingleNews feed;
  const SingleNewsHeader({Key? key, required this.feed}) : super(key: key);

  @override
  _SingleNewsHeaderState createState() => _SingleNewsHeaderState();
}

class _SingleNewsHeaderState extends State<SingleNewsHeader> {
  late bool _isFollowing;
  bool _isRequestOn = false;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.feed.followID != null;
  }

  void onFinish() async {
    setState(() {
      _isRequestOn = true;
    });
    try {
      if (_isFollowing == true) {
        await sources.unfollow(widget.feed.sourceID);
      } else {
        await sources.follow(widget.feed.sourceID);
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isRequestOn = false;
        _isFollowing = !_isFollowing;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(),
            ),
            Column(
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
        Row(
          children: [
            ScaleButton(
              disabled: _isRequestOn,
              child: _isFollowing == true
                  ? Icon(
                      Icons.done_all,
                      size: 32,
                    )
                  : Icon(
                      Icons.add,
                      size: 32,
                    ),
              onFinish: onFinish,
            ),
            PopupMenuButton(
              iconSize: 32,
              offset: Offset(0, 40),
              itemBuilder: (entry) {
                return [
                  PopupMenuItem(
                    child: Text("test"),
                  ),
                ];
              },
            ),
          ],
        ),
      ],
    );
  }
}
