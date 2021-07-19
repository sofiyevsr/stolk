import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:feedapp/screens/splash.dart';
import 'package:feedapp/utils/constants.dart';
import 'package:feedapp/utils/themes/index.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import "package:hive_flutter/hive_flutter.dart";

import 'components/HomeWrapper.dart';
import 'logic/blocs/authBloc/utils/AuthBloc.dart';
import 'logic/hive/settings.dart';
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
    Hive.registerAdapter(SettingsAdapter());
    await Hive.openBox<Settings>("settings");
    // await LocalNotification.instance.init();
    // await Firebase.initializeApp();
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // FirebaseMessaging.onMessage.listen((event) {});

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
    print(exception);
  });
  FlutterError.onError = (details, {bool forceReport = false}) {
    print(details);
    // sentry.captureException(
    //   exception: details.exception,
    //   stackTrace: details.stack,
    // );
  };
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: darkTheme,
        // themeMode: ThemeMode.dark,
        theme: lightTheme,
        builder: (ctx, child) {
          return HomeWrapper(child: child);
        },
        navigatorKey: NavigationService.key,
        scaffoldMessengerKey: ToastService.key,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        // TODO implement
        // onGenerateTitle: ,
        onGenerateRoute: (_) => NavigationService.wrapRoute(
          SplashScreen(),
          RouteNames.SPLASH,
        ),
      ),
    );
  }
}
