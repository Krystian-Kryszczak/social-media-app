import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../io/storage/files_picker.dart';
import '../../../../language/language.dart';

class MediaCollector extends StatelessWidget {
  final void Function(List<File>) prepareMedia;
  final void Function()? setPreview;

  const MediaCollector({
    super.key,
    required this.prepareMedia,
    this.setPreview
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double imageSize = math.min(mediaQuery.size.width, 500);

    return MaterialButton(
      height: math.max(mediaQuery.size.height - imageSize - 105.0, 200.0),
      child: Center(
        child: Text(
          Language.getLangPhrase(Phrase.selectImages),
          style: TextStyle(
            fontSize: 32.0,
            color: Theme.of(context).colorScheme.primary
          )
        ),
      ),
      onPressed: () => FilesPicker.pickMedia().then((res) {
        if (res != null) prepareMedia(res);
      }),
    );
  }
}
