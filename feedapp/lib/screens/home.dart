import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

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
            activeColor: Colors.grey.shade800,
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
            AllNewsScreen(),
            AllNewsScreen(),
            AllNewsScreen(),
            AllNewsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
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
