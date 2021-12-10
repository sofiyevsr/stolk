import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
  HomeWrapper({Key? key, this.child});

  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  @override
  void initState() {
    super.initState();
    StartupService.instance.checkTokenAndSaveDeviceToken().catchError((error) {
      FirebaseAnalytics.instance.logEvent(name: "appException", parameters: {
        "message": error.toString(),
      });
      // Start token refresh after
      FirebaseCrashlytics.instance.recordFlutterError(
        error,
      );
    }).whenComplete(() => StartupService.instance.startNotificationStream());
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
              Home(),
              RouteNames.HOME,
            );
          else
            NavigationService.replaceAll(
              CompleteProfile(),
              RouteNames.COMPLETE_PROFILE,
            );
        }
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
