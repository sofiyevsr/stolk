import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/screens/auth/completeProfile.dart';
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
  const HomeWrapper({Key? key, this.child}) : super(key: key);

  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  @override
  void initState() {
    super.initState();
    StartupService.instance
        .checkTokenAndSaveDeviceToken()
        .catchError((_) {})
        .whenComplete(() => StartupService.instance.startNotificationStream());
  }

  @override
  void dispose() {
    // Stops refresh token stream
    StartupService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(ctx) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is AuthorizedState) {
          if (state.user.completedAt != null)
            NavigationService.replaceAll(
              const Home(),
              RouteNames.HOME,
            );
          else
            NavigationService.replaceAll(
              const CompleteProfile(),
              RouteNames.COMPLETE_PROFILE,
            );
        }
        if (state is UnathorizedState)
          NavigationService.replaceAll(
            const IntroductionWrapper(),
            RouteNames.INTRODUCTION,
          );
        if (state is CheckTokenFailed)
          NavigationService.replaceAll(
            const CheckTokenFailScreen(),
            RouteNames.CHECKTOKENFAIL,
          );
      },
      child: widget.child,
    );
  }
}
