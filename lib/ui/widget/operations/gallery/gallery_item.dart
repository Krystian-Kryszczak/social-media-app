import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/ui/widget/snapshot/snapshot_handler.dart';
import 'package:mime/mime.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class GalleryItem extends StatefulWidget {
  final AssetEntity data;
  // ------------------------- //
  final bool isPreview;
  final int Function(File) getSelectedIndex;
  final bool showSelected;
  final void Function() onTapImage;
  final int Function() getImageIndex;

  const GalleryItem({
    super.key,
    required this.data,
    this.isPreview = false,
    required this.getSelectedIndex,
    this.showSelected = false,
    required this.onTapImage,
    required this.getImageIndex
  });

  @override
  State<GalleryItem> createState() => _GalleryItemState();
}

class _GalleryItemState extends State<GalleryItem> {
  late Future<File?>? future;
  @override
  void initState() {
    super.initState();
    future = widget.data.file;
  }
  @override
  Widget build(BuildContext context) {
    const double circleSize = 18.0;
    return FutureBuilder<File?>(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        File? file = snapshot.data;
        if (file != null) {
          String? mineType = lookupMimeType(file.absolute.path);
          bool isVideo = mineType != null && mineType.startsWith("video");
          Widget thumbnail = Image.file(file, fit: BoxFit.cover);
          if (isVideo) {
            var data = VideoThumbnail.thumbnailData(
              video: file.absolute.path,
              imageFormat: ImageFormat.WEBP,
              quality: 75
            );
            thumbnail = FutureBuilder(
              future: data,
              builder: (context, snapshot) => SnapshotHandler(context: context, snapshot: snapshot,
                onSuccess: snapshot.data != null ? Image.memory(snapshot.data!) : thumbnail
              ),
            );
          }
          return InkWell(
              onTap: widget.onTapImage,
              child: Container(
                color: Theme.of(context).colorScheme.background,
                child: Stack(
                    children: [
                      Center(child: thumbnail),
                      AnimatedContainer(
                        color: widget.isPreview ? Theme.of(context).colorScheme.primary.withOpacity(.25) : Colors.transparent,
                        duration: const Duration(milliseconds: 250),
                      ),
                      if (isVideo) ...[
                        const Center(
                          child: Icon(Icons.play_circle_outline, size: 42.0),
                        )
                      ],
                      if (widget.showSelected) () {
                        int selectedIndex = widget.getSelectedIndex(file);
                        return Positioned(
                            right: 7.5, bottom: 7.5,
                            child: Stack(
                              children: [
                                CustomPaint(
                                  size: const Size(circleSize, circleSize),
                                  painter: CirclePainter(),
                                ),
                                if (selectedIndex > -1) Container(
                                  width: circleSize,
                                  height: circleSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).colorScheme.secondary
                                  ),
                                  child: Center(child: Text((selectedIndex+1).toString())),
                                )
                              ],
                            )
                        );
                      }()
                    ]
                ),
              )
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class CirclePainter extends CustomPainter {
  final _paint = Paint()
    ..strokeWidth = 2.25
    ..style = PaintingStyle.stroke;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), _paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
