import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/settings/settings.dart';
import 'package:frontend/ui/style/palette/palette.dart';
import 'package:frontend/ui/style/theme/app_theme.dart';
import 'package:provider/provider.dart';

import 'language/language.dart';
import 'launch/behavior/custom_scroll_behavior.dart';
import 'launch/launcher.dart';
import 'launch/routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Launcher.configurePlatform();
  // ------------------------- //
  runApp(
    ChangeNotifierProvider(
      create: (context) => Language(),
      child: App(initialRoute: await AppRouter.initialRoute)
    )
  );
}

class App extends StatefulWidget {
  final String initialRoute;

  const App({
    super.key,
    required this.initialRoute
  });

  @override
  State<App> createState() => AppState();

  static AppState of(BuildContext context) => context.findAncestorStateOfType<AppState>()!;
}

class AppState extends State<App> {
  ThemeMode _themeMode = Settings.themeMode;
  Lang lang = Language.selectedLang;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // -------------------------------------------------- //
    return MaterialApp(
      title: Palette.appTitleData,
      // ------------------------- //
      debugShowCheckedModeBanner: false,
      scrollBehavior: CustomScrollBehavior(),
      // ------------------------- //
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      // ------------------------- //
      initialRoute: widget.initialRoute,
      routes: AppRouter.routers,
    );
  }

  void changeThemeMode(ThemeMode themeMode) {
    setState(() => _themeMode = themeMode);
    Settings.setThemeMode(themeMode);
  }

  void changeLanguage(Lang language) {
    Language.changeLanguage(language);
    setState(() => lang = language);
  }
}
