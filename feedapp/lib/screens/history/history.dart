import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/logic/blocs/newsHistoryBloc/newsHistory.dart';
import 'package:stolk/screens/history/widgets/singleNewsHistoryUnit.dart';
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
    final theme = Theme.of(context);
    return Row(
      children: [
        NavigationRail(
          backgroundColor: theme.scaffoldBackgroundColor,
          minWidth: 55,
          destinations: [
            NavigationRailDestination(
              icon: Icon(Icons.favorite_outline),
              selectedIcon: Icon(
                Icons.favorite_sharp,
                color: theme.indicatorColor,
              ),
              label: Text("like"),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.comment_outlined),
              selectedIcon: Icon(
                Icons.comment_sharp,
                color: theme.indicatorColor,
              ),
              label: Text("comment"),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(
                Icons.history_sharp,
                color: theme.indicatorColor,
              ),
              label: Text("history"),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.bookmark_outline),
              selectedIcon: Icon(
                Icons.bookmark_sharp,
                color: theme.indicatorColor,
              ),
              label: Text("bookmark"),
            ),
          ],
          selectedIndex: _currentIndex,
          onDestinationSelected: (s) {
            if (_pageController.hasClients && mounted) {
              setState(() {
                _currentIndex = s;
              });
              _pageController.jumpToPage(
                s,
              );
            }
          },
        ),
        VerticalDivider(
          thickness: 4,
        ),
        Expanded(
          child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            if (state is AuthorizedState)
              return PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                itemCount: 4,
                itemBuilder: (ctx, i) => Container(
                  child: BlocProvider(
                    key: Key(_pages[i]),
                    create: (ctx) => NewsHistoryBloc(),
                    child: SingleNewsHistoryUnit(filterBy: _pages[i]),
                  ),
                ),
                scrollDirection: Axis.vertical,
              );
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 45),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    "assets/lottie/settings.json",
                  ),
                  Text(
                    tr("errors.login_to_track"),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
