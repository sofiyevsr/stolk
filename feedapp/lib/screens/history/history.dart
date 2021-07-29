import 'package:feedapp/logic/blocs/newsBloc/news.dart';
import 'package:feedapp/screens/history/widgets/singleNewsHistoryUnit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _pages = ["like", "comment", "history", "bookmark"];

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _currentIndex = 0;
  late PageController _pageController;
  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          minWidth: 55,
          destinations: [
            NavigationRailDestination(
              icon: Icon(Icons.favorite_outline),
              label: Text("like"),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.comment_outlined),
              label: Text("comment"),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.history_outlined),
              label: Text("history"),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.bookmark_outline),
              label: Text("bookmark"),
            ),
          ],
          selectedIndex: _currentIndex,
          onDestinationSelected: (s) {
            setState(() {
              _currentIndex = s;
            });
            _pageController.animateToPage(
              s,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
        VerticalDivider(
          thickness: 4,
        ),
        Expanded(
          child: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            itemCount: 4,
            itemBuilder: (ctx, i) => Container(
              child: BlocProvider(
                key: Key(_pages[i]),
                create: (ctx) => NewsBloc()
                  ..add(
                    FetchNewsEvent(
                      category: null,
                      filterBy: _pages[i],
                    ),
                  ),
                child: SingleNewsHistoryUnit(),
              ),
            ),
            scrollDirection: Axis.vertical,
          ),
        ),
      ],
    );
  }
}
