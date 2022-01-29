import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/components/ads/adaptiveBanner.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/logic/blocs/sourcesBloc/sources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/utils/ads/constants.dart';

import 'feed/allNews.dart';
import 'history/history.dart';
import 'settings/settings.dart';
import 'sources/sources.dart';

final navItems = [
  {"icon": Icons.rss_feed_sharp, "title": "navbar.home"},
  {"icon": Icons.explore_sharp, "title": "navbar.explore"},
  {"icon": Icons.bookmark_sharp, "title": "navbar.bookmarks"},
  {"icon": Icons.manage_accounts_sharp, "title": "navbar.account"},
];

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  PageController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/icons/logo.png", width: 56.0),
            const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Text(
                "Stolk",
                style: TextStyle(
                  fontSize: 34,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            BlocProvider<NewsBloc>(
              create: (ctx) => NewsBloc(),
              child: const AllNewsScreen(),
            ),
            BlocProvider<SourcesBloc>(
              create: (ctx) => SourcesBloc(),
              child: const SourcesPage(),
            ),
            const HistoryPage(),
            const SettingsPage(),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AdaptiveBannerAd(
            unitID: getUnitID(AdPlacements.home),
            disabled: false,
          ),
          BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
                _controller?.jumpToPage(index);
              },
              items: navItems
                  .map(
                    (e) => BottomNavigationBarItem(
                      backgroundColor:
                          theme.bottomNavigationBarTheme.backgroundColor,
                      label: (e["title"] as String).tr(),
                      icon: Icon(e["icon"] as IconData),
                    ),
                  )
                  .toList()),
        ],
      ),
    );
  }
}
