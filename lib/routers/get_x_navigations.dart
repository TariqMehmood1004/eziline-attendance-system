import 'package:flutter/material.dart';

class GetXNavigate {
  static final GetXNavigate _instance = GetXNavigate._internal();

  factory GetXNavigate() {
    return _instance;
  }

  GetXNavigate._internal();

  static GetXNavigate get instance => _instance;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> replaceTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }

  void goBackUntil(String routeName) {
    return navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
  }

  void goBackAll() {
    return navigatorKey.currentState!.popUntil((route) => false);
  }

  void goBackAllUntil(String routeName) {
    return navigatorKey.currentState!
        .popUntil((route) => route.settings.name == routeName);
  }

  void removeUntil(String routeName) {
    return navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
  }
}
