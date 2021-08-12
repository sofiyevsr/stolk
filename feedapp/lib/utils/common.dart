import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/components/auth/views/AuthView.dart';
import 'package:stolk/logic/blocs/authBloc/utils/AuthBloc.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/app/navigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeago/timeago.dart' as timeago;

class Nullable<T> {
  final T? value;
  Nullable({required this.value});
}

String shortenString(String s, int limit) =>
    s.length <= limit ? s : s.replaceRange(limit, s.length, '...');

String convertTime(String date, BuildContext context) {
  final lang = EasyLocalization.of(context)?.currentLocale?.languageCode;
  final data = DateTime.tryParse(date)?.toLocal();
  if (data == null) {
    return "";
  }
  final format = DateFormat("HH:mm, d MMMM", lang ?? "en");
  return format.format(data);
}

ThemeMode stringToTheme(String theme) {
  if (theme == "dark") {
    return ThemeMode.dark;
  }
  if (theme == "light") {
    return ThemeMode.light;
  }
  return ThemeMode.system;
}

String convertDiffTime(String date, BuildContext context) {
  final lang = EasyLocalization.of(context)?.currentLocale?.languageCode;
  final data = DateTime.tryParse(date)?.toLocal();
  if (data == null) {
    return "";
  }
  return timeago.format(data, locale: lang);
}

class LimitRangeTextInputFormatter extends TextInputFormatter {
  LimitRangeTextInputFormatter(this.min, this.max) : assert(min < max);

  final int min;
  final int max;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == "") return newValue;
    var value = int.tryParse(newValue.text);
    if (value == null) return oldValue;
    if (value < min || value > max) {
      return oldValue;
    }
    return newValue;
  }
}

// When user is not logged in push AuthView
authorize() {
  final auth = AuthBloc.instance.state;
  if (auth is! AuthorizedState) {
    NavigationService.push(AuthView(isLogin: true), RouteNames.AUTH);
    throw Error();
  }
}
