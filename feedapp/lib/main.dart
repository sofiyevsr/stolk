import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:stolk/screens/splash.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/logger.dart';
import 'package:stolk/utils/themes/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:hive_flutter/hive_flutter.dart";

import 'components/HomeWrapper.dart';
import 'logic/blocs/authBloc/utils/AuthBloc.dart';
import 'utils/common.dart';
import 'utils/services/app/navigationService.dart';
import 'utils/services/app/toastService.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

Future<void> _loadInternalization() async {
  await EasyLocalization.ensureInitialized();
  timeago.setLocaleMessages("az", timeago.AzMessages());
  timeago.setLocaleMessages("ru", timeago.RuMessages());
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(() async {
    await _loadInternalization();

    await Hive.initFlutter();
    // Open box to use in app
    await Hive.openBox("settings");
    // await LocalNotification.instance.init();
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((event) {});
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(
      EasyLocalization(
        supportedLocales: [
          Locale('en'),
          Locale('az'),
          Locale('ru'),
        ],
        useOnlyLangCode: true,
        path: 'assets/translations',
        fallbackLocale: Locale('az'),
        child: App(),
      ),
    );
  }, (exception, trace) {
    FirebaseCrashlytics.instance.recordError(exception, trace);
  });
}

class App extends StatelessWidget {
  final AuthBloc authBloc = AuthBloc.instance;

  @override
  Widget build(context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(
          value: authBloc,
        ),
      ],
      child: ValueListenableBuilder(
          valueListenable: Hive.box('settings').listenable(keys: ["theme"]),
          builder: (context, Box gBox, widget) {
            final theme = gBox.get("theme", defaultValue: "system");
            return MaterialApp(
              title: "Stolk",
              debugShowCheckedModeBanner: false,
              darkTheme: darkTheme,
              themeMode: stringToTheme(theme),
              theme: lightTheme,
              builder: (ctx, child) {
                return HomeWrapper(child: child);
              },
              navigatorKey: NavigationService.key,
              scaffoldMessengerKey: ToastService.key,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              navigatorObservers: [
                AppLogger.instance.getFirebaseAnalyticsObserver()
              ],
              locale: context.locale,
              onGenerateRoute: (_) => NavigationService.wrapRoute(
                SplashScreen(),
                RouteNames.SPLASH,
                disableAnimation: false,
              ),
            );
          }),
    );
  }
}
