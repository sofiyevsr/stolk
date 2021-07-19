import 'package:flutter/material.dart';

final apiUrl = "http://localhost:4500/";

class AppPlatform {
  static const WEB = 0;
  static const IOS = 1;
  static const ANDROID = 2;
}

class SessionType {
  static const WEB = 0;
  static const IOS = 1;
  static const ANDROID = 2;
}

class ServiceType {
  static const APP = 0;
}

class AccountType {
  static const USER = 0;
  static const PARTNER = 1;
}

String platformToName(int p) {
  if (p == AppPlatform.WEB) {
    return "WEB";
  }
  if (p == AppPlatform.IOS) {
    return "IOS";
  }
  if (p == AppPlatform.ANDROID) {
    return "ANDROID";
  }
  return "";
}

class BusinessType {
  static const FOOD = 0;
  static const CLOTHING = 1;
}

class ClosedBanners {
  static const MY_BOOKINGS = 0;
}

class CampaignStatus {
  static const FREE = 0;
  static const PREMIUM = 1;
}

class CustomColorScheme {
  static final main = const Color(0xFFe76f51);
  static final logoBackground = const Color.fromRGBO(255, 221, 238, 1);
}

class RouteNames {
  static const CHECKTOKENFAIL = "check_token_fail";
  static const INTRODUCTION = "introduction";
  static const SPLASH = "splash";
  static const SETTINGS = "settings";
  static const SINGLE_BOOKING = "single_booking";
  static const BOOKINGS = "bookings";
  static const HOME = "home";
  static const AUTH = "auth";
  static const SINGLE_CAMPAIGN = "single_campaign";
  static const MY_BOOKINGS = "my_bookings";
  static const SINGLE_SETTING = "single_setting";
}

const DEFAULT_RADIUS = 1000;
const DEFAULT_CATS = [BusinessType.FOOD, BusinessType.CLOTHING];
const List<int> DEFAULT_BANNERS = [];
