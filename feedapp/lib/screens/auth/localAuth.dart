import "package:flutter/material.dart";
import 'package:stolk/views/LocalAuthView.dart';

class LocalAuthPage extends StatefulWidget {
  final bool isLogin;
  const LocalAuthPage({Key? key, this.isLogin = true}) : super(key: key);

  @override
  _LocalAuthPageState createState() => _LocalAuthPageState();
}

class _LocalAuthPageState extends State<LocalAuthPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  bool _isLogin = true;

  @override
  void initState() {
    super.initState();

    _controller = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.isLogin == true ? 0 : 1,
    )..addListener(() {
        final kIndex = _controller.index == 0;
        if (_isLogin != kIndex) {
          setState(() {
            _isLogin = kIndex;
          });
        }
      });

    setState(() {
      _isLogin = _controller.index == 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LocalAuthView(isLogin: _isLogin, controller: _controller),
      ),
    );
  }
}
