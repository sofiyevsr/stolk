import 'dart:async';

import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/utils/services/app/secureStorage.dart';
import 'package:stolk/utils/services/server/authService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stolk/utils/services/server/notificationService.dart';

class StartupService {
  static final instance = StartupService._();
  StreamSubscription<String>? tokenRefreshStream;
  StartupService._();

  Future<void> storeDeviceToken(String? authToken) async {
    final permissions = await FirebaseMessaging.instance.requestPermission();
    if (permissions.authorizationStatus == AuthorizationStatus.authorized) {
      // Get the token each time the application loads
      String? token = await FirebaseMessaging.instance.getToken();

      print('token $token');
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
    storeDeviceToken(token).catchError((e) {
      print('error while getting device token $e');
    });
    await _checkToken(token);
  }

  Future<void> _saveTokenToDatabase(String? token, String? authToken) async {
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
