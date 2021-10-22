import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/utils/services/app/secureStorage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stolk/utils/services/server/notificationService.dart';

class StartupService {
  static final instance = StartupService._();
  StreamSubscription<String>? tokenRefreshStream;
  StartupService._();

  void dispose() {
    tokenRefreshStream?.cancel();
  }

  Future<void> storeDeviceToken() async {
    final permissions = await FirebaseMessaging.instance.requestPermission();
    if (permissions.authorizationStatus == AuthorizationStatus.authorized) {
      // Any time the token refreshes, store this in the database too.
      if (tokenRefreshStream == null)
        tokenRefreshStream = FirebaseMessaging.instance.onTokenRefresh.listen(
          (token) {
            final authState = AuthBloc.instance.state;
            if (authState is AuthorizedState) {
              saveNotificationTokenToDatabase(token, authState.token);
            }
          },
        );
    }
  }

  Future<void> checkTokenAndSaveDeviceToken() async {
    final storage = SecureStorage();
    final token = await storage.getToken();
    await _checkToken(token);
    // if check token fails it is okay to stop store device token
    storeDeviceToken().catchError((e) {
      FirebaseCrashlytics.instance.log('error while getting device token $e');
    });
  }

  Future<void> saveNotificationTokenToDatabase(
    String? token,
    String? authToken,
  ) async {
    final notificationService = NotificationService();
    if (token != null && authToken != null)
      await notificationService.saveToken(token, authToken);
  }

  Future<void> _checkToken(String? token) async {
    if (token != null) {
      AuthBloc.instance.add(CheckTokenEvent(token: token));
    } else {
      AuthBloc.instance.add(StartupLogout());
    }
  }
}
