import 'dart:async';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/screens/feed/widgets/newsView.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import 'package:stolk/utils/services/app/secureStorage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stolk/utils/services/server/notificationService.dart';

class StartupService {
  static final instance = StartupService._();
  // To avoid sending request twice
  bool _isTokenSaveInProgress = false;
  StreamSubscription<String>? _tokenRefreshStream;
  StreamSubscription<RemoteMessage>? _remoteMessageStream;
  StartupService._();

  void dispose() {
    _remoteMessageStream?.cancel();
    _tokenRefreshStream?.cancel();
  }

  Future<void> startFCMInteraction() async {
    _remoteMessageStream =
        FirebaseMessaging.onMessageOpenedApp.listen(_handleFCMMessage);
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _handleFCMMessage(message);
    }
  }

  Future<void> storeDeviceToken(String? authToken) async {
    final permissions = await FirebaseMessaging.instance.requestPermission();
    if (permissions.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();
    // Save the initial token to the database
    await _saveTokenToDatabase(token, authToken);
  }

  void startNotificationStream() {
    // Any time the token refreshes, store this in the database too.
    _tokenRefreshStream ??= FirebaseMessaging.instance.onTokenRefresh.listen(
      (token) {
        final authState = AuthBloc.instance.state;
        if (authState is AuthorizedState) {
          _saveTokenToDatabase(token, authState.token).catchError((_) {});
        } else {
          _saveTokenToDatabase(token, null).catchError((_) {});
        }
      },
    );
  }

  Future<void> checkTokenAndSaveDeviceToken() async {
    final storage = SecureStorage();
    final token = await storage.getToken();
    _checkToken(token);
    await storeDeviceToken(token);
  }

  void _handleFCMMessage(RemoteMessage message) {
    if (message.data["type"] == "webview_open" &&
        message.data["link"] != null) {
      NavigationService.pushAndRemoveUntil(
        NewsView(link: message.data["link"]),
        RouteNames.SINGLE_NEWS,
        removeUntil: RouteNames.HOME,
      );
    }
  }

  Future<void> _saveTokenToDatabase(String? token, String? authToken) async {
    if (_isTokenSaveInProgress == true) return;
    _isTokenSaveInProgress = true;
    try {
      if (token == null) return;
      final notificationService = NotificationService();
      await notificationService.saveToken(token, authToken);
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
