import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// final apiUrl = "http://167.99.136.121:4500/";
final apiUrl =
    kReleaseMode ? "https://api.stolk.app/" : "http://localhost:4500/";
final websiteURL = "https://stolk.app/";
final privacyPolicyURL = websiteURL + "privacy-policy";
final termsOfUseURL = websiteURL + "terms-of-use";
final sourceLogosPrefix =
    "https://stolk.s3.eu-west-3.amazonaws.com/source-logos/";
final categoryImagesPrefix =
    "https://stolk.s3.eu-west-3.amazonaws.com/category-images/";

const Map<int, String> LANGS = {0: "az", 1: "tr", 2: "ru", 3: "en"};

class AppPlatform {
  static const IOS = 0;
  static const ANDROID = 1;
}

Map<String, String> fcmNotificationChannels = {
  "news": "news",
};

class NotificationOptoutType {
  // Unless user optouts latest news from one of sources user follow will be sent each ... days
  static const SourceFollow = 0;
}

class SessionType {
  static const IOS = 0;
  static const ANDROID = 1;
}

class ServiceType {
  static const APP = 0;
}

String platformToName(int p) {
  if (p == AppPlatform.IOS) {
    return "IOS";
  }
  if (p == AppPlatform.ANDROID) {
    return "ANDROID";
  }
  return "";
}

class CustomColorScheme {
  static final main = const Color(0xFF264653);
  static final accent = const Color(0xFF2A9D8F);
  static final primaryLight = const Color(0xFF6497ab);
  static final primaryDark = const Color(0xFF203B46);
  static final logoBackground = const Color.fromRGBO(255, 221, 238, 1);
}

class RouteNames {
  static const CHECKTOKENFAIL = "check_token_fail";
  static const INTRODUCTION = "introduction";
  static const SPLASH = "splash";
  static const SINGLE_SETTING = "single_setting";
  static const SOURCE_NEWS_FEED = "source_news_feed";
  static const SETTINGS = "settings";
  static const SINGLE_NEWS = "single_news";
  static const HOME = "home";
  static const AUTH = "auth";
  static const LOCAL_AUTH = "local_auth";
  static const FORGOT_PASSWORD = "forgot_password";
}

final passwordRegex =
    RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&_^-]{7,}$");
