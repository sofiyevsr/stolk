import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:stolk/components/introduction/DotsIndicator.dart';
import 'package:stolk/components/introduction/IntroLogin.dart';
import 'package:stolk/components/introduction/IntroPage.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final gBox = Hive.box("settings");
  final PageController _controller = PageController();
  int _current = 0;
  final _length = 3;

  void nextPage() {
    if (_current < _length) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void onPageChange(int i) {
    setState(() {
      _current = i;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    gBox.put("skipIntro", true);
    super.dispose();
  }

  @override
  Widget build(ctx) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DotsIndicator(length: _length, current: _current),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: onPageChange,
                children: <Widget>[
                  IntroPage(
                    nextPage: nextPage,
                    image: "assets/static/launch.png",
                    title: tr("intro.first.title"),
                    subtitle: tr("intro.first.subtitle"),
                  ),
                  IntroPage(
                    nextPage: nextPage,
                    image: "assets/static/paper-illustration.png",
                    title: tr("intro.second.title"),
                    subtitle: tr("intro.second.subtitle"),
                  ),
                  IntroPage(
                    nextPage: nextPage,
                    image: "assets/static/phone-news.png",
                    title: tr("intro.third.title"),
                    subtitle: tr("intro.third.subtitle"),
                  ),
                  const IntroLogin(),
                ],
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
