import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AppLogger {
  static final instance = AppLogger._();
  static final analytics = FirebaseAnalytics.instance;
  AppLogger._();

  FirebaseAnalyticsObserver getFirebaseAnalyticsObserver() {
    return FirebaseAnalyticsObserver(analytics: analytics);
  }

  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) {
    return analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  Future<void> logError({
    dynamic exception,
    StackTrace? stack,
    String? reason,
    bool isFatal = false,
  }) {
    return FirebaseCrashlytics.instance.recordError(
      exception,
      stack,
      reason: reason,
      fatal: isFatal,
    );
  }
}
