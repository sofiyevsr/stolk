import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/screens/home.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import 'package:stolk/utils/services/app/startupService.dart';
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
