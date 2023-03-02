import 'package:flutter/material.dart';

import '../../../../language/language.dart';
import '../../../../main.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({
    super.key
  });

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  Lang language = Language.selectedLang;
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(language.getLangPhrase(Phrase.language))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: Lang.values.length,
          itemBuilder: (context, index) {
            Lang lang = Lang.values.elementAt(index);
            return LanguageTile(
              title: language.getLangPhrase(lang.langPhrase),
              subtitle: lang==language ? language.getLangPhrase(Phrase.selected) : null,
              onPressed: () {
                App.of(context).changeLanguage(lang);
                setState(() { language = Language.selectedLang; });
                (ModalRoute.of(context)!.settings.arguments as void Function(void Function()))(() {});
              },
            );
          },
        )
      )
    );
  }
}

class LanguageTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final void Function() onPressed;

  const LanguageTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(title),
    subtitle: subtitle!=null ? Text(subtitle??'') : null,
    onTap: onPressed
  );
}
