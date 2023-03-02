import 'package:flutter/material.dart';
import 'package:frontend/launch/routes/app_router.dart';

import '../../../language/language.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key
  });

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  Lang lang = Language.selectedLang;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Language.getLangPhrase(Phrase.settings))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(Language.getLangPhrase(Phrase.language)),
              subtitle: Text(Language.getLangPhrase(Language.selectedLang.langPhrase)),
              onTap: () => Navigator.pushNamed(context, AppRouter.languageSettingsRoute, arguments: setState)),
            ListTile(
              leading: const Icon(Icons.format_paint),
              title: Text(Language.getLangPhrase(Phrase.themeMode)),
              onTap: () => Navigator.pushNamed(context, AppRouter.themeSettingsRoute),
            )
          ],
        ),
      ),
    );
  }
}
