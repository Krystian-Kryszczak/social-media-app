import 'package:flutter/material.dart';

import '../../../media/media_viewer.dart';

class ImagePreview extends StatelessWidget {
  final Image image;

  const ImagePreview({
    super.key,
    required this.image
  });

  @override
  Widget build(BuildContext context) {
    return MediaViewer(media: image);
  }
}
