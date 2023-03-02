import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NetworkFiles {
  static Widget getNetworkImage({required String url, Widget Function(BuildContext, ImageProvider)? imageBuilder, Widget? fallback, double? width, double? height, BoxFit? fit}) => CachedNetworkImage(
    imageUrl: url,
    progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(
      value: downloadProgress.progress,
      color: Theme.of(context).colorScheme.primary.withOpacity(downloadProgress.progress ?? 1.0)
    ),
    imageBuilder: imageBuilder,
    width: width,
    height: height,
    fit: fit,
    errorWidget: (context, url, error) => fallback ?? const Icon(Icons.error),
  );
  static ImageProvider getImageProvider({required String url}) => CachedNetworkImageProvider(url);
  static VideoPlayerController getNetworkVideo({required String url}) => VideoPlayerController.network(url);
}
