import 'package:feedapp/logic/blocs/authBloc/auth.dart';
import 'package:feedapp/logic/blocs/newsBloc/news.dart';
import 'package:feedapp/screens/home.dart';
import 'package:feedapp/utils/constants.dart';
import 'package:feedapp/utils/services/app/navigationService.dart';
import 'package:feedapp/utils/services/app/startupService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'error/views/checkTokenFail.dart';
import 'introduction/Wrapper.dart';

class HomeWrapper extends StatefulWidget {
  final Widget? child;
  HomeWrapper({Key? key, this.child});

  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  @override
  void initState() {
    super.initState();
    print("wrapper");
    StartupService.instance
        .checkTokenAndSaveDeviceToken()
        .catchError((error) {});
  }

  @override
  Widget build(ctx) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is AuthorizedState)
          NavigationService.replaceAll(
            Home(),
            RouteNames.HOME,
          );
        if (state is UnathorizedState)
          NavigationService.replaceAll(
            IntroductionWrapper(),
            RouteNames.INTRODUCTION,
          );
        if (state is CheckTokenFailed)
          NavigationService.replaceAll(
            CheckTokenFailScreen(),
            RouteNames.CHECKTOKENFAIL,
          );
      },
      child: widget.child,
    );
  }
}
