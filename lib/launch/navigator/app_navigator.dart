import 'package:flutter/material.dart';

import '../../ui/overlay/overlay_tab_bar.dart';

class AppNavigator {
  final BuildContext context;
  late final NavigatorState navigator;

  AppNavigator({
    required this.context,
  }) {
    navigator = Navigator.of(context);
  }

  static AppNavigator of(BuildContext context) => AppNavigator(context: context);

  Future<void> popAll() async {
    while (navigator.canPop()) {
      navigator.pop();
    }
  }
  Future<void> popAllAndPushNamed(String routeName, {Object? arguments}) async => popAll().whenComplete(() => navigator.pushNamed(routeName, arguments: arguments));
  void setBarPosition(int index, {Duration duration = const Duration(seconds: 0)}) => controller.animateTo(index, duration: duration);
  void openDrawer() => context.findAncestorStateOfType<ScaffoldState>()?.openEndDrawer();
}
