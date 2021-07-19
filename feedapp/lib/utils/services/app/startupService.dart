import 'dart:async';

import 'package:feedapp/logic/blocs/authBloc/auth.dart';
import 'package:feedapp/utils/services/app/secureStorage.dart';
import 'package:feedapp/utils/services/server/authService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class StartupService {
  static final instance = StartupService._();
  StreamSubscription<String>? tokenRefreshStream;
  StartupService._();

  Future<void> storeDeviceToken(String? authToken) async {
    final permissions = await FirebaseMessaging.instance.requestPermission();
    if (permissions.authorizationStatus == AuthorizationStatus.authorized) {
      // Get the token each time the application loads
      String? token = await FirebaseMessaging.instance.getToken();

      // Save the initial token to the database
      await _saveTokenToDatabase(token, authToken);

      // Any time the token refreshes, store this in the database too.
      tokenRefreshStream?.cancel();
      tokenRefreshStream =
          FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        _saveTokenToDatabase(token, authToken);
      });
    }
  }

  Future<void> checkTokenAndSaveDeviceToken() async {
    final storage = SecureStorage();
    final token = await storage.getToken();
    // if check token fails it is okay to stop store device token
    storeDeviceToken(token).catchError((e) {});
    await _checkToken(token);
  }

  Future<void> _saveTokenToDatabase(String? token, String? authToken) async {
    final authService = AuthService();
    if (token != null) await authService.saveToken(token, authToken);
  }

  Future<void> _checkToken(String? token) async {
    if (token != null) {
      AuthBloc.instance.add(CheckTokenEvent(token: token));
    } else {
      AuthBloc.instance.add(StartupLogout());
    }
  }
}
