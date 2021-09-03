import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/components/common/sourceLogo.dart';
import 'package:stolk/utils/@types/response/allSources.dart';
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
          Text(
            widget.item.name,
            style: Theme.of(context).textTheme.headline6,
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
          ElevatedButton(
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: _isRequestOn ? null : onFinish,
            child: _isFollowing == true
                ? Text("commons.following").tr()
                : Text("commons.follow").tr(),
          ),
        ],
      ),
    );
  }
}
