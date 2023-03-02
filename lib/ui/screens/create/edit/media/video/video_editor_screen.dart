import 'dart:io';

import 'package:flutter/material.dart';

class VideoEditorScreen extends StatelessWidget {
  const VideoEditorScreen({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final List<File> args = ModalRoute.of(context)!.settings.arguments as List<File>;
    return const Scaffold(); // TODO
  }
}
