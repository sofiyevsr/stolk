import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final apiUrl =
    kReleaseMode ? "https://api.stolk.app/" : "http://localhost:4500/";
const websiteURL = "https://stolk.app/";
const privacyPolicyURL = websiteURL + "privacy-policy";
const termsOfUseURL = websiteURL + "terms-of-use";
const sourceLogosPrefix = "https://assets.stolk.app/source-logos/";
const categoryImagesPrefix = "https://assets.stolk.app/category-images/";

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

class NewsSortBy {
  static const POPULAR = 0;
  static const LATEST = 1;
  static const MOST_LIKED = 2;
  static const MOST_READ = 3;
}

String sortByToString(int s) {
  if (s == NewsSortBy.LATEST) {
    return "latest";
  } else if (s == NewsSortBy.MOST_LIKED) {
    return "most_liked";
  } else if (s == NewsSortBy.MOST_READ) {
    return "most_read";
  } else if (s == NewsSortBy.POPULAR) {
    return "popular";
  }
  return "";
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
  static const main = Color(0xFFDF9273);
  static const accent = Color(0xFFFF687B);
  static const cardColor = Color(0xFF2A2B2E);
  static const primaryLight = Color(0xFFE3A48A);
  static const primaryDark = Color(0xFFd68463);
  static const logoBackground = Color.fromRGBO(255, 221, 238, 1);
  // used for icon button background
  static const darkButtonBackground = Color(0xFF36373A);
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
  static const FORGOT_PASSWORD = "forgot_password";
  static const COMPLETE_PROFILE = "complete_profile";
}

final passwordRegex =
    RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&_^-]{7,}$");

class HiveDefaultValues {
  static const SORT_BY = 0;
  static const PERIOD = 1;
}
