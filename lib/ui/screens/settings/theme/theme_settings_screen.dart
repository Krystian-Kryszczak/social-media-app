import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../language/language.dart';
import '../../../../main.dart';
import '../../../../settings/settings.dart';

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({
    super.key
  });

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    Map<ThemeMode, Phrase> data = {
      ThemeMode.light: Phrase.light,
      ThemeMode.dark: Phrase.dark,

      if (!kIsWeb) ThemeMode.system: Phrase.system
    };

    return Scaffold(
      appBar: AppBar(title: Text(Language.getLangPhrase(Phrase.themeMode))),
      body: FutureBuilder(
        future: Settings.getThemeMode(),
        builder: (BuildContext _, AsyncSnapshot<ThemeMode> snapshot) {
          if (snapshot.hasData) {
            ThemeMode selected = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => Tile(
                  title: Language.getLangPhrase(data.values.elementAt(index)),
                  subtitle: selected==data.keys.elementAt(index) ? Language.getLangPhrase(Phrase.selected) : null,
                  onPressed: () {
                    Settings.setThemeMode(data.keys.elementAt(index));
                    App.of(context).changeThemeMode(data.keys.elementAt(index));
                    setState(() {});
                  },
                )
              ),
            );
          } else if (snapshot.hasError) {
            return Column(children: [
              const Icon(Icons.error_outline, color: Colors.red,size: 60),
              Padding(padding: const EdgeInsets.only(top: 16), child: Text('${Language.getLangPhrase(Phrase.error)}: ${snapshot.error}'))
            ]);
          } else {
            return Column(children: [
              const SizedBox( width: 60, height: 60, child: CircularProgressIndicator()),
              Padding(padding: const EdgeInsets.only(top: 16), child: Text(Language.getLangPhrase(Phrase.loading)))
            ]);
          }
        },
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final void Function() onPressed;

  const Tile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(title),
    subtitle: subtitle!=null ? Text(subtitle!) : null,
    onTap: onPressed
  );
}
