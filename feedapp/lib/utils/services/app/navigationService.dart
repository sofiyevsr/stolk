import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import "dart:io" show Platform;

class NavigationService {
  static final _key = GlobalKey<NavigatorState>();
  static List<String> currentStack = [];
  static GlobalKey<NavigatorState> get key => _key;
  static Route wrapRoute(Widget child, String name) {
    currentStack.add(name);
    if (Platform.isAndroid)
      return MaterialPageRoute(
        builder: (_) => child,
        settings: RouteSettings(name: name),
      );
    else
      return CupertinoPageRoute(
        builder: (_) => child,
        settings: RouteSettings(name: name),
      );
  }

  static void pop() {
    // On pop we
    currentStack.removeLast();
    NavigationService.key.currentState!.pop();
  }

  static void push(Widget child, String name) {
    NavigationService.key.currentState!
        .push(NavigationService.wrapRoute(child, name));
  }

  static void replaceCurrent(Widget child, String name) {
    NavigationService.key.currentState!
        .pushReplacement(NavigationService.wrapRoute(child, name));
  }

  static void replaceAll(Widget child, String name) {
    NavigationService.key.currentState!.pushAndRemoveUntil(
        NavigationService.wrapRoute(child, name), (route) => false);
  }
}
