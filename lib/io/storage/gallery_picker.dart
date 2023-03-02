import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryPicker {
  static bool get canGetImages => (!kIsWeb && Platform.isAndroid || Platform.isIOS || Platform.isMacOS);

  static Stream<AssetEntity> albums() async* {
    List<AssetPathEntity> albums = [];
    List<AssetEntity> media = [];
    if (await PhotoManager.requestPermissionExtend().then((permission) => permission.hasAccess)) {
      log('PhotoManager » Permission allowed.');
      albums = await PhotoManager.getAssetPathList(type: RequestType.all, onlyAll: true, hasAll: true); // Recent
      // media = await albums[1].getAssetListRange(start: 0, end: 10);
      for (AssetPathEntity album in albums) {
        List<AssetEntity> assets = await album.getAssetListRange(start: 0, end: 100);
        media.addAll(assets);
      }
      media.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));
    } else {
      log('PhotoManager » Permission denied.');
    }
    for (int i=0; i<media.length; i++) {
      AssetEntity asset = media.elementAt(i);
      log(await asset.titleAsync);
      yield asset;
    }
  }

  static Stream<AssetEntity> videos() async* {
    List<AssetPathEntity> videos = [];
    List<AssetEntity> media = [];
    if (await PhotoManager.requestPermissionExtend().then((permission) => permission.hasAccess)) {
      log('PhotoManager » Permission allowed.');
      videos = await PhotoManager.getAssetPathList(type: RequestType.video, onlyAll: true, hasAll: true);
      for (AssetPathEntity album in videos) {
        List<AssetEntity> assets = await album.getAssetListRange(start: 0, end: 20);
        media.addAll(assets);
      }
      media.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));
    } else {
      log('PhotoManager » Permission denied.');
    }
    for (int i=0; i<media.length; i++) {
      AssetEntity asset = media.elementAt(i);
      log(await asset.titleAsync);
      yield asset;
    }
  }

  static Stream<AssetEntity> images() async* {
    List<AssetPathEntity> images = [];
    List<AssetEntity> media = [];
    if (await PhotoManager.requestPermissionExtend().then((permission) => permission.hasAccess)) {
      log('PhotoManager » Permission allowed.');
      images = await PhotoManager.getAssetPathList(type: RequestType.image, onlyAll: true, hasAll: true);
      for (AssetPathEntity album in images) {
        List<AssetEntity> assets = await album.getAssetListRange(start: 0, end: 20);
        media.addAll(assets);
      }
      media.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));
    } else {
      log('PhotoManager » Permission denied.');
    }
    for (int i=0; i<media.length; i++) {
      AssetEntity asset = media.elementAt(i);
      log(await asset.titleAsync);
      yield asset;
    }
  }
}
