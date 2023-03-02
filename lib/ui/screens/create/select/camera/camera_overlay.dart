import 'package:flutter/material.dart';
import 'package:frontend/ui/screens/camera/camera_screen.dart';

class CameraOverlay extends StatefulWidget {
  final CameraScreen camera;
  final List<Widget> sidebarWidgets;

  const CameraOverlay({
    super.key,
    required this.camera,
    this.sidebarWidgets = const []
  });

  @override
  State<CameraOverlay> createState() => _CameraOverlayState();
}

class _CameraOverlayState extends State<CameraOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.camera,
      ]
    );
    // TODO gallery under camera
  }
}
