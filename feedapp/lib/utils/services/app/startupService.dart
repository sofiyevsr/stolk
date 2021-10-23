import 'dart:async';
import 'package:hive/hive.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/utils/services/app/secureStorage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stolk/utils/services/server/notificationService.dart';

class StartupService {
  static final instance = StartupService._();
  final _settingsBox = Hive.box("settings");
  // To avoid sending request twice
  bool _isTokenSaveInProgress = false;
  StreamSubscription<String>? _tokenRefreshStream;
  StartupService._();

  void dispose() {
    _tokenRefreshStream?.cancel();
  }

  Future<void> storeDeviceToken(String? authToken) async {
    final permissions = await FirebaseMessaging.instance.requestPermission();
    if (permissions.authorizationStatus != AuthorizationStatus.authorized) {
      throw Error();
    }
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();
    // Save the initial token to the database
    await _saveTokenToDatabase(token, authToken);
  }

  void startNotificationStream() {
    // Any time the token refreshes, store this in the database too.
    if (_tokenRefreshStream == null)
      _tokenRefreshStream = FirebaseMessaging.instance.onTokenRefresh.listen(
        (token) {
          final authState = AuthBloc.instance.state;
          if (authState is! AuthorizedState) return;
          _saveTokenToDatabase(token, authState.token);
        },
      );
  }

  Future<void> checkTokenAndSaveDeviceToken() async {
    final storage = SecureStorage();
    final token = await storage.getToken();
    _checkToken(token);
    await storeDeviceToken(token);
  }

  Future<void> deleteToken() async {
    // Delete token after state is yielded to avoid onTokenRefresh function to resave token
    await FirebaseMessaging.instance.deleteToken();
    await this.deleteTokenLocally();
  }

  Future<void> deleteTokenLocally() async {
    await _settingsBox.put("notificationToken", null);
  }

  Future<void> _saveTokenToDatabase(String? token, String? authToken) async {
    if (_isTokenSaveInProgress == true) return;
    _isTokenSaveInProgress = true;
    try {
      if (token == null || authToken == null) return;
      final lastSavedNofifToken = await _settingsBox.get("notificationToken");
      if (lastSavedNofifToken == token) return;
      final notificationService = NotificationService();
      await notificationService.saveToken(token, authToken);
      await _settingsBox.put("notificationToken", token);
    } catch (_) {
      rethrow;
    } finally {
      _isTokenSaveInProgress = false;
    }
  }

  void _checkToken(String? token) {
    if (token != null) {
      AuthBloc.instance.add(CheckTokenEvent(token: token));
    } else {
      AuthBloc.instance.add(StartupLogout());
    }
  }
}
