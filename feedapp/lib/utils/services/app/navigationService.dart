import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import "dart:io" show Platform;

class NavigationService {
  static final _key = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> get key => _key;
  static Route wrapRoute(
    Widget child,
    String name, {
    required bool disableAnimation,
  }) {
    if (disableAnimation == true)
      return PageRouteBuilder(
        pageBuilder: (_, __, ___) => child,
        settings: RouteSettings(name: name),
        transitionDuration: Duration.zero,
      );
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
    NavigationService.key.currentState!.pop();
  }

  static void popUntil(String name) {
    NavigationService.key.currentState!
        .popUntil((route) => route.settings.name == name);
  }

  static void pushAndRemoveUntil(
    Widget child,
    String name, {
    required String removeUntil,
    bool disableAnimation = false,
  }) {
    NavigationService.key.currentState!.pushAndRemoveUntil(
      NavigationService.wrapRoute(
        child,
        name,
        disableAnimation: disableAnimation,
      ),
      (route) => route.settings.name == removeUntil,
    );
  }

  static void push(
    Widget child,
    String name, {
    bool disableAnimation = false,
  }) {
    NavigationService.key.currentState!.push(
      NavigationService.wrapRoute(
        child,
        name,
        disableAnimation: disableAnimation,
      ),
    );
  }

  static void replaceCurrent(
    Widget child,
    String name, {
    bool disableAnimation = false,
  }) {
    NavigationService.key.currentState!.pushReplacement(
      NavigationService.wrapRoute(
        child,
        name,
        disableAnimation: disableAnimation,
      ),
    );
  }

  static void replaceAll(
    Widget child,
    String name, {
    bool disableAnimation = false,
  }) {
    NavigationService.key.currentState!.pushAndRemoveUntil(
      NavigationService.wrapRoute(
        child,
        name,
        disableAnimation: disableAnimation,
      ),
      (route) => false,
    );
  }
}
