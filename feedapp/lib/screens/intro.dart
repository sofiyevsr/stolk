import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stolk/components/introduction/DotsIndicator.dart';
import 'package:stolk/components/introduction/IntroPage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stolk/utils/constants.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  PageController _controller = PageController();
  int _current = 0;
  final _length = 3;

  void nextPage() {
    if (_current < _length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void prevPage() {
    if (_current >= 0) {
      _controller.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void skipIntro(BuildContext ctx) {
    final gBox = Hive.box("settings");
    gBox.put("skipIntro", true);
  }

  void onPageChange(int i) {
    setState(() {
      _current = i;
    });
  }

  @override
  Widget build(ctx) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PageView(
                onPageChanged: onPageChange,
                children: <Widget>[
                  IntroPage(
                    image: "assets/static/hand-phone.png",
                    title: tr("intro.first.title"),
                    subtitle: tr("intro.first.subtitle"),
                  ),
                  IntroPage(
                    image: "assets/static/paper-illustration.png",
                    title: tr("intro.second.title"),
                    subtitle: tr("intro.second.subtitle"),
                  ),
                  IntroPage(
                    image: "assets/static/phone-news.png",
                    title: tr("intro.third.title"),
                    subtitle: tr("intro.third.subtitle"),
                  ),
                ],
                controller: _controller,
              ),
            ),
            Container(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: prevPage,
                      child: Text(
                        tr("intro.prev"),
                      ),
                    ),
                  ),
                  DotsIndicator(length: _length, current: _current),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (_current == (_length - 1)) {
                          skipIntro(ctx);
                        } else
                          nextPage();
                      },
                      child: Text(
                        (_current == (_length - 1))
                            ? tr("intro.finish")
                            : tr("intro.next"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
