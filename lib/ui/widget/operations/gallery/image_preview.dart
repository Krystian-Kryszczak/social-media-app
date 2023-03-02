import 'dart:math';

import 'package:flutter/material.dart';

import '../../media/media_viewer.dart';

class ImagePreview extends StatelessWidget {
  final Widget media;

  const ImagePreview({
    super.key,
    required this.media
  });

  @override
  Widget build(BuildContext context) {
    final double size = min(MediaQuery.of(context).size.width, 500);
    return SliverToBoxAdapter(
      child: SizedBox(
        width: size,
        height: size,
        child: MediaViewer(media: media)
      )
    );
  }
}
