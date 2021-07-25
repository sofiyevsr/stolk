import 'package:flutter/material.dart';

final apiUrl = "http://localhost:4500/";

const Map<int, String> LANGS = {0: "az", 1: "tr", 2: "ru", 3: "en"};

class AppPlatform {
  static const IOS = 0;
  static const ANDROID = 1;
}

class SessionType {
  static const IOS = 0;
  static const ANDROID = 1;
}

class ServiceType {
  static const APP = 0;
}

class AccountType {
  static const USER = 0;
  static const PARTNER = 1;
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
  static final main = const Color(0xFFe76f51);
  static final logoBackground = const Color.fromRGBO(255, 221, 238, 1);
}

class RouteNames {
  static const CHECKTOKENFAIL = "check_token_fail";
  static const INTRODUCTION = "introduction";
  static const SPLASH = "splash";
  static const SINGLE_SETTING = "single_setting";
  static const SETTINGS = "settings";
  static const SINGLE_NEWS = "single_news";
  static const HOME = "home";
  static const AUTH = "auth";
}

final passwordRegex =
    RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&_^-]{7,}$");
