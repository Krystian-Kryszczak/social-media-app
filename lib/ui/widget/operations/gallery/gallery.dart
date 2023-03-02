import "dart:developer";
import "dart:io";

import 'package:file_picker/file_picker.dart';
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import 'package:frontend/ui/widget/snapshot/snapshot_handler.dart';
import "package:photo_manager/photo_manager.dart";

import '../../../../io/storage/gallery_picker.dart';
import "../../../../language/language.dart";
import "gallery_item.dart";
import "images_collector.dart";

class Gallery extends StatefulWidget {
  final int previewIndex;
  final FileType fileType;
  final void Function(int index) setMediaPreview;
  final void Function(int index) setSelectedImageOverlay;
  final int Function() getImagePreviewIndex;
  final void Function(List<File> images) prepareImages;

  const Gallery({
    super.key,
    required this.previewIndex,
    required this.fileType,
    required this.setMediaPreview,
    required this.setSelectedImageOverlay,
    required this.getImagePreviewIndex,
    required this.prepareImages
  });

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool multiChoice = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SliverToBoxAdapter(
      child: SizedBox(
        width: size.width,
        height:size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                primary: false,
                title: Text(
                  Language.getLangPhrase(Phrase.gallery),
                  style: TextStyle(color: Theme.of(context).colorScheme.primary)
                ),
                automaticallyImplyLeading: false,
                actions: GalleryPicker.canGetImages ? [IconButton(icon: const Icon(FontAwesomeIcons.layerGroup, size: 18),
                color: multiChoice ? Theme.of(context).colorScheme.primary : null,
                onPressed: () => setState(() => multiChoice = !multiChoice))] : [],
              ),
              GalleryPicker.canGetImages
                ? _ImagesGrid(
                  previewIndex: widget.previewIndex,
                  fileType: widget.fileType,
                  setMediaPreview: widget.setMediaPreview,
                  setSelectedMediaOverlay: widget.setSelectedImageOverlay,
                  prepareMedia: widget.prepareImages,
                  multiChoice: multiChoice,
                ) : MediaCollector(prepareMedia: widget.prepareImages, setPreview: () => widget.setMediaPreview(0)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagesGrid extends StatefulWidget {
  final int previewIndex;
  final FileType fileType;
  final void Function(int index) setMediaPreview;
  final void Function(int index) setSelectedMediaOverlay;
  final void Function(List<File>) prepareMedia;
  final bool multiChoice;

  const _ImagesGrid({
    super.key,
    required this.setMediaPreview,
    required this.fileType,
    required this.setSelectedMediaOverlay,
    required this.prepareMedia,
    required this.previewIndex,
    required this.multiChoice
  });

  @override
  State<_ImagesGrid> createState() => _ImagesGridState();
}

class _ImagesGridState extends State<_ImagesGrid> {
  late Future<List<AssetEntity>> future;

  @override
  void initState() {
    super.initState();
    switch (widget.fileType) {
      case FileType.image:
        future = GalleryPicker.images().toList();
        break;
      case FileType.video:
        future = GalleryPicker.videos().toList();
        break;
      default:
        future = GalleryPicker.albums().toList();
    }
    future = future.then((mediaList) { // init image preview
      if (mediaList.isNotEmpty) {
        mediaList.first.file.then((file) { // get latest file
          if (file!=null) {
            widget.prepareMedia([file]); // move up files to publish overlay widget
            widget.setMediaPreview(0); // replace app progress indicator to image
            widget.setSelectedMediaOverlay(0);
          }
        });
      }
      return mediaList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AssetEntity>>(
      future: future.onError((error, stackTrace) {
        log('ImagesGrid');
        log('error');
        log(error.toString());
        log('stackTrace');
        log(stackTrace.toString());
        throw Error();
      }),
      builder: (context, snapshot) {
        List<AssetEntity> assets = snapshot.data ?? [];
        return SnapshotHandler(context: context, snapshot: snapshot,
            onSuccess: assets.isNotEmpty ? GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0
            ),
            padding: const EdgeInsets.all(1.0),
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: transform(assets),
          ) : MediaCollector(prepareMedia: widget.prepareMedia)
        );
      }
    );
  }
  List<File> media = [];
  int lastSelected = 0;
  // int prevSelected = 0;
  List<Widget> transform(List<AssetEntity> assets) {
    List<Widget> widgets = [];
    if (!widget.multiChoice) {
      if (assets.length-1 > lastSelected) {
        assets[lastSelected].file.then((file) {
          if (file!=null) media = [file];
        });
      }
    }
    for (int i=0; i<assets.length; i++) {
      AssetEntity asset = assets[i];
      widgets.add(
        GalleryItem(
          data: asset,
          isPreview: i == widget.previewIndex,
          showSelected: widget.multiChoice,
          getSelectedIndex: getIndexOfFile, // map key - def index value - sorted
          onTapImage: () async {
            Future<int> getIndexOfFileAssets(File file) async {
              int i = 0;
              for (AssetEntity asset in assets) {
                if (file.path == ((await asset.file)?.path??'_')) return i;
                i++;
              }
              return -1;
            }
            File? file = await asset.file;
            if (file!=null) {
              if (widget.multiChoice) { // multi choice
                int fileIndex = getIndexOfFile(file); // check if images contains selected (clicked) image
                if (fileIndex > -1) { // images not contains selected image
                  if (lastSelected==i) { // check if image preview current is set to this item
                    // If true remove this item //
                    media.removeAt(fileIndex); // remove from images

                    // update images in publish overlay //
                    widget.prepareMedia(media.isNotEmpty ? media : [file]); // Images list have not to be empty because that's makes errors.

                    // after remove //
                    int previouslySelected = fileIndex != 0 ? fileIndex-1 : media.length-1;
                    if (previouslySelected > -1) { // change selected overlay and log info about changed image preview
                      widget.setMediaPreview(previouslySelected);
                      // lastSelected = previouslySelected;
                      File prevSelectedMediaFile = media[previouslySelected]; // from images list
                      // ------------------------- //
                      log('Preview media was changed to ${prevSelectedMediaFile.path.split(RegExp('\\/')).last}.');

                      int prevSelectedImageOverlayIndex = await getIndexOfFileAssets(prevSelectedMediaFile);
                      if (prevSelectedImageOverlayIndex>-1) {
                        WidgetsBinding.instance.addPostFrameCallback((_) => lastSelected = prevSelectedImageOverlayIndex); // without WidgetsBinding image selected overlay not works correct!
                        widget.setSelectedMediaOverlay(prevSelectedImageOverlayIndex);
                      }
                    }
                  } else {
                    widget.setMediaPreview(i); // change image preview
                  }
                } else { // images contains selected image
                  int j = media.length;
                  media.add(file);
                  widget.prepareMedia(media); // move up
                  widget.setMediaPreview(j); // preview image index from moved up list
                }
              } else { // single choice
                media = [file];
                widget.prepareMedia(media); // move up
                widget.setMediaPreview(0); // set image preview
              }
              if (lastSelected!=i) { // if selected image is different than current
                widget.setSelectedMediaOverlay(i); // set selected item overlay
                log('Preview media was changed${asset.title!=null ? ' to ${asset.title}' : ''}.');
                lastSelected = i;
              }
            }
          }, getImageIndex: () => media.length + 1,
        )
      );
    }
    return widgets;
  }

  int getIndexOfFile(File file) {
    int i = 0;
    for (File image in media) {
      if (file.path==image.path) return i;
      i++;
    }
    return -1;
  }
}
