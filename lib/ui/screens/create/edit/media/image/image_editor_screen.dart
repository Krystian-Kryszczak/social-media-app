import 'dart:io';

import 'package:flutter/material.dart';

class ImageEditorScreen extends StatelessWidget {
  const ImageEditorScreen({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final List<File> args = ModalRoute.of(context)!.settings.arguments as List<File>;
    return const Scaffold(); // TODO
  }
}
