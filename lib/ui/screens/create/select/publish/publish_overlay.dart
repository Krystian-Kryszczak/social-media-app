import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../widget/operations/gallery/gallery.dart';
import '../../../../widget/operations/gallery/image_preview.dart';
import '../../../../widget/operations/publish/publish_app_bar.dart';
import '../../../../widget/progress/app_progress_indicator.dart';
import '../../../../widget/snapshot/snapshot_handler.dart';

class PublishOverlay extends StatefulWidget {
  final String title;
  final FileType fileType;
  final String nextStepRoute;

  const PublishOverlay({
    super.key,
    required this.title,
    this.fileType = FileType.media,
    required this.nextStepRoute,
  });

  @override
  State<PublishOverlay> createState() => _PublishOverlayState();
}

class _PublishOverlayState extends State<PublishOverlay> {
  Widget media = const Center(
    child: FractionallySizedBox(
      widthFactor: .4,
      heightFactor: .4,
      child: AppProgressIndicator()
    ),
  );
  List<File> files = [];
  int previewIndex = 0; // item index of the image map
  int selectedIndex = 0; // gallery images section selected item overlay index

  void setImages(List<File> list) => setState(() => files = list);

  void setImagePreview(int index) {
    if (files.isNotEmpty) {
      previewIndex = index;
      File file = files[min(previewIndex, files.length-1)];
      String? mineType = lookupMimeType(file.absolute.path);
      bool isImage = mineType != null && mineType.startsWith("image");
      if (isImage) {
        setState(() => media = Image.file(file));
      } else {
        var data = VideoThumbnail.thumbnailData(
            video: file.absolute.path,
            imageFormat: ImageFormat.PNG,
            quality: 75
        );
        media = FutureBuilder(
          future: data,
          builder: (context, snapshot) => SnapshotHandler(context: context, snapshot: snapshot,
              onSuccess: snapshot.data != null ? Image.memory(snapshot.data!) : ErrorWidget('')
          ),
        );
      }
    }
  }

  void setSelectedImageOverlay(int index) => setState(() => selectedIndex = index);

  int getImagePreviewIndex() => previewIndex;

  void editImages(BuildContext context) => Navigator.pushNamed(context, widget.nextStepRoute, arguments: files);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PublishAppBar(
        onPressed: () => editImages(context),
        title: Text(widget.title),
        iconColor: Theme.of(context).colorScheme.primary
      ),
      body: CustomScrollView(
        slivers: [
          ImagePreview(media: media),
          Gallery(
            previewIndex: selectedIndex,
            fileType: widget.fileType,
            setMediaPreview: setImagePreview,
            setSelectedImageOverlay: setSelectedImageOverlay,
            getImagePreviewIndex: getImagePreviewIndex,
            prepareImages: setImages
          ),
        ]
      ),
    );
  }
}
