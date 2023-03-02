import 'package:flutter/material.dart';

import '../../../widget/operations/publish/publish_app_bar.dart';

class EditorBase extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget preview;
  final Widget options;

  const EditorBase({
    super.key,
    required this.onPressed,
    required this.preview,
    required this.options
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PublishAppBar(onPressed: onPressed, title: const Icon(Icons.brush)),
    );
  }
}
