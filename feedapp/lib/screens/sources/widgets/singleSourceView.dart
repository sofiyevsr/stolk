import 'package:feedapp/components/common/sourceLogo.dart';
import 'package:feedapp/utils/@types/response/allSources.dart';
import 'package:feedapp/utils/services/server/sourceService.dart';
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
            child: SizedBox.expand(
              child: Container(
                margin: const EdgeInsets.all(8),
                child: SourceLogo(
                  logoSuffix: widget.item.logoSuffix,
                  isCircle: false,
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: _isRequestOn ? null : onFinish,
            child: _isFollowing == true ? Text("following") : Text("follow"),
          ),
        ],
      ),
    );
  }
}
