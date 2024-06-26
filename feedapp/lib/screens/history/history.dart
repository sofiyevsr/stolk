import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:stolk/components/common/lottieLoader.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/screens/history/widgets/bookmarks.dart';
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
      if (state is AuthorizedState) {
        return BlocProvider(
          create: (ctx) => NewsBloc(),
          child: Bookmarks(),
        );
      }
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 45),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LottieLoader(
              asset: "assets/lottie/bookmark.json",
              size: Size(200, 200),
              repeat: false,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              width: 200,
              child: Text(
                tr("errors.login_for_bookmarks"),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    });
  }
}
