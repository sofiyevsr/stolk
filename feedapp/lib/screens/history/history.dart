import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/screens/history/widgets/singleNewsHistoryUnit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthorizedState)
        return Container(
          child: BlocProvider(
            create: (ctx) => NewsBloc(),
            child: SingleNewsHistoryUnit(),
          ),
        );
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 45),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              "assets/lottie/bookmark.json",
            ),
            Text(
              tr("errors.login_for_bookmarks"),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    });
  }
}
