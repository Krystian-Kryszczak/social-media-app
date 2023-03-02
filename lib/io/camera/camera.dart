import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../ui/screens/camera/camera_screen.dart';

class CameraData {
  // -------------------------------------------------- //
  static late List<CameraDescription> _cameras;
  // ------------------------- //«·»// ------------------------- //
  static Future<void> loadAvailableCameras() async => _cameras = await availableCameras();
  static List<CameraDescription> getAvailableCameras() => _cameras;
  static Map<IconData, FlashMode> flashMap = {
    Icons.flash_off: FlashMode.off,
    Icons.flash_auto: FlashMode.auto,
    Icons.flash_on: FlashMode.always,
    Icons.highlight: FlashMode.torch
  };
  // -------------------------------------------------- //
  static CameraScreen getCamera({void Function()? onTake}) => CameraScreen(cameras: getAvailableCameras(), onTake: onTake);
  // -------------------------------------------------- //
}
