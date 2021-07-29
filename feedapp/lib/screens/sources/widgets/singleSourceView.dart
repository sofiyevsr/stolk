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
        children: [
          Text(widget.item.name),
          Expanded(
            child: SizedBox.expand(
              child: Container(
                margin: const EdgeInsets.all(8),
                child: CircleAvatar(
                  child: Text("test"),
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _isRequestOn ? null : onFinish,
            icon: _isFollowing == true
                ? Icon(Icons.remove_outlined)
                : Icon(Icons.add_outlined),
            label: Text("follow"),
          ),
        ],
      ),
    );
  }
}
