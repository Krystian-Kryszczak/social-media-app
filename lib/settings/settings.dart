import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../io/storage/local_storage.dart';

class Settings {
  // -------------------------------------------------- //
  static late ThemeMode _themeMode;
  // -------------------------------------------------- //
  static Future<void> loadSettings() async {
    _themeMode = await getThemeMode().onError((error, stackTrace) {
      log(stackTrace.toString());
      return ThemeMode.system;
    });
  }
  // -------------------------------------------------- //
  static Future<ThemeMode> getThemeMode() async {
    String? theme = await LocalStorage.readString(key: 'ThemeMode');
    if (theme!=null) {
      if (theme=='light') {
        return ThemeMode.light;
      } else if (theme=='dark') {
        return ThemeMode.dark;
      } else if (!kIsWeb && theme=='system') {
        return ThemeMode.system;
      }
    }
    return LocalStorage.writeString(key: 'ThemeMode', value: !kIsWeb?'system':'dark').then((value) => !kIsWeb?ThemeMode.system:ThemeMode.dark);
  }
  static Future<bool> setThemeMode(ThemeMode themeMode) async {
    String theme = 'dark';
    if (!kIsWeb && themeMode==ThemeMode.system) {
      theme = 'system';
    } else if (themeMode==ThemeMode.light) {
      theme = 'light';
    }
    return LocalStorage.writeString(key: 'ThemeMode', value: theme).whenComplete(() {
      Settings._themeMode = themeMode;
      log('ThemeMode was changed to $themeMode');
    });
  }
  static ThemeMode get themeMode => _themeMode;
  // -------------------------------------------------- //
}