import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/logic/blocs/sourcesBloc/sources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'feed/allNews.dart';
import 'history/history.dart';
import 'settings/settings.dart';
import 'sources/sources.dart';

final navItems = [
  {"icon": Icons.home, "title": "navbar.home"},
  {"icon": Icons.explore, "title": "navbar.explore"},
  {"icon": Icons.bookmark_sharp, "title": "navbar.bookmarks"},
  {"icon": Icons.account_box, "title": "navbar.account"},
];

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  PageController? _controller;

  List<BottomNavigationBarItem> _buildNavItems(BuildContext ctx) {
    final theme = Theme.of(ctx);
    return navItems
        .map(
          (e) => BottomNavigationBarItem(
            backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
            label: (e["title"] as String).tr(),
            icon: Icon(e["icon"] as IconData),
          ),
        )
        .toList();
  }

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
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("assets/icons/logo.png"),
        title: Text(
          "Stolk",
          style: TextStyle(
            fontSize: 32,
          ),
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
              child: AllNewsScreen(),
            ),
            BlocProvider<SourcesBloc>(
              create: (ctx) => SourcesBloc(),
              child: SourcesPage(),
            ),
            HistoryPage(),
            SettingsPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _controller?.jumpToPage(index);
        },
        items: _buildNavItems(context),
      ),
    );
  }
}
