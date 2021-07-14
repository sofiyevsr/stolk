import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:feedapp/logic/blocs/newsBloc/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'feed/allNews.dart';

final navItems = [
  {"icon": Icons.home, "title": "home"},
  {"icon": Icons.explore, "title": "explore"},
  {"icon": Icons.chat, "title": "discussion"},
  {"icon": Icons.account_box, "title": "profile"},
];

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  PageController? _controller;

  List<BottomNavyBarItem> _buildNavItems(BuildContext ctx) {
    final theme = Theme.of(ctx);
    return navItems
        .map(
          (e) => BottomNavyBarItem(
            title: Text(
              e["title"] as String,
            ),
            icon: Icon(e["icon"] as IconData),
            inactiveColor: theme.primaryColor,
            activeColor: theme.accentColor,
            textAlign: TextAlign.center,
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
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        child: PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            BlocProvider<NewsBloc>(
              create: (ctx) => NewsBloc()
                ..add(
                  FetchNewsEvent(),
                ),
              child: AllNewsScreen(),
            ),
            AllNewsScreen(),
            AllNewsScreen(),
            AllNewsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        curve: Curves.easeInOut,
        backgroundColor: theme.bottomAppBarColor,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _controller?.jumpToPage(index);
        },
        items: _buildNavItems(context),
      ),
    );
  }
}
