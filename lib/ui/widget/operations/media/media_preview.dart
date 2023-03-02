import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/service/media/media_service.dart';

import '../../../../language/language.dart';
import '../gallery/image_preview.dart';
import 'audio/audio_preview.dart';
import 'video/video_preview.dart';

class MediaPreview extends StatelessWidget {
  final File media;

  const MediaPreview({
    super.key,
    required this.media
  });

  @override
  Widget build(BuildContext context) {
    if (MediaService.fileIsImage(file: media)) {
      return ImagePreview(media: Image.file(media));
    } else if (MediaService.fileIsVideo(file: media)) {
      return const VideoPreview(); // TODO
    } else if (MediaService.fileIsAudio(file: media)) {
      return const AudioPreview(); // TODO
    } else {
      return Center(child: Text(Language.getLangPhrase(Phrase.error)));
    }
  }
}
