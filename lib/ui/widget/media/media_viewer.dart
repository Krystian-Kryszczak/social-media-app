import 'package:flutter/material.dart';

class MediaViewer extends StatelessWidget {
  final Widget media;

  const MediaViewer({
    super.key,
    required this.media
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        minScale: 1.0,
        maxScale: 4.0,
        child: FractionallySizedBox(
          heightFactor: 1.0,
          child: media
        )
      )
    );
  }
}
