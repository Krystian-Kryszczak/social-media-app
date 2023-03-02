import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import '../../../io/camera/camera.dart';
import '../../../language/language.dart';
import '../../../service/media/media_service.dart';
import 'camera_settings_screen.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final void Function()? onTake;

  const CameraScreen({
    super.key,
    required this.cameras,
    this.onTake
  });

  @override
  State<CameraScreen> createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  // ----------------------------------- //
  CameraController? controller;
  int selectedCameraIndex = 0;
  // ----------------------------------- //
  VideoPlayerController? videoController;
  // ----------------------------------- //
  File? _imageFile, _videoFile;
  // ----------------------------------- //

  @override
  void initState() {
    getPermissionStatus();
    // ----------------------------------- //
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.initState();
    // ----------------------------------- //
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // ----------------------------------- //
    controller?.dispose();
    videoController?.dispose();
    super.dispose();
  }
  // ----------------------------------- //
  // Initial values
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  final bool _isVideoCameraSelected = false;
  bool _isRecordingInProgress = false;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  // ----------------------------------- //
  // Current values
  double _currentZoomLevel = 1.0;
  double _currentExposureOffset = 0.0;
  FlashMode _currentFlashMode = FlashMode.off;
  // -------------------- //
  List<File> allFileList = [];
  // -------------------- //
  final ResolutionPreset resolutionPreset = ResolutionPreset.max;
  // ----------------------------------- //
  void getPermissionStatus() async {
    if (await Permission.camera.request().isGranted) {
      log('Camera Permission: GRANTED');
      setState(() => _isCameraPermissionGranted = true);
      // Set and initialize the new camera
      onNewCameraSelected(widget.cameras[0]);
      refreshAlreadyCapturedImages();
    } else {
      log('Camera Permission: DENIED');
    }
  }
  refreshAlreadyCapturedImages() async {
    final directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> fileList = await directory.list().toList();
    allFileList.clear();
    List<Map<int, dynamic>> fileNames = [];
    for (var file in fileList) {
      if (MediaService.fileIsVisible(path: file.path)) {
        allFileList.add(File(file.path));
        String name = file.path.split('/').last.split('.').first;
        fileNames.add({0: int.parse(name), 1: file.path.split('/').last});
      }
    }
    if (fileNames.isNotEmpty) {
      final recentFile = fileNames.reduce((curr, next) => curr[0] > next[0] ? curr : next);
      String recentFileName = recentFile[1];
      if (MediaService.fileIsVideo(path: recentFileName)) {
        _videoFile = File('${directory.path}/$recentFileName');
        _imageFile = null;
        _startVideoPlayer();
      } else {
        _imageFile = File('${directory.path}/$recentFileName');
        _videoFile = null;
      }
      setState((){});
    }
  }
  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) return null; // A capture is already pending, do nothing.
    try {
      return await cameraController.takePicture();
    } on CameraException catch (e) {
      log('Error occurred while taking picture: $e');
      return null;
    }
  }

  Future<void> _startVideoPlayer() async {
    if (_videoFile != null) {
      videoController = VideoPlayerController.file(_videoFile!);
      // Ensure the first frame is shown after the video is initialized,
      // even before the play button has been pressed.
      await videoController!.initialize().then((_)=>setState((){}));
      await videoController!.setLooping(true);
      await videoController!.play();
    }
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;
    if (controller!.value.isRecordingVideo) return; // A recording has already started, do nothing.
    try {
      await cameraController!.startVideoRecording();
      setState(() {
        _isRecordingInProgress = true;
        log('Recording in progress.');
      });
    } on CameraException catch (e) {
      log('Error starting to record video: $e');
    }
  }

  Future<XFile?> stopVideoRecording() async {
    if (!controller!.value.isRecordingVideo) return null; // Recording is already is stopped state
    try {
      XFile file = await controller!.stopVideoRecording();
      setState(()=>_isRecordingInProgress = false);
      return file;
    } on CameraException catch (e) {
      log('Error stopping video recording: $e');
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    if (!controller!.value.isRecordingVideo) return; // Video recording is not in progress
    try {
      await controller!.pauseVideoRecording();
    } on CameraException catch (e) {
      log('Error pausing video recording: $e');
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller!.value.isRecordingVideo) return; // No video recording was in progress
    try {
      await controller!.resumeVideoRecording();
    } on CameraException catch (e) {
      log('Error resuming video recording: $e');
    }
  }

  void resetCameraValues() async {
    _currentZoomLevel = 1.0;
    _currentExposureOffset = 0.0;
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    final CameraController cameraController = CameraController(
      cameraDescription,
      resolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    await previousCameraController?.dispose();

    resetCameraValues();

    if (mounted) setState(() => controller = cameraController);

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await cameraController.initialize();
      await Future.wait([
        cameraController.getMinExposureOffset().then((value) => _minAvailableExposureOffset = value),
        cameraController.getMaxExposureOffset().then((value) => _maxAvailableExposureOffset = value),
        cameraController.getMaxZoomLevel().then((value) => _maxAvailableZoom = value),
        cameraController.getMinZoomLevel().then((value) => _minAvailableZoom = value),
      ]);
      _currentFlashMode = controller!.value.flashMode;
    } on CameraException catch (e) {
      log('Error initializing camera: $e');
    }
    if (mounted) setState(()=> _isCameraInitialized = controller!.value.isInitialized);
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) return;
    final offset = Offset(details.localPosition.dx / constraints.maxWidth, details.localPosition.dy / constraints.maxHeight);
    controller!.setExposurePoint(offset);
    controller!.setFocusPoint(offset);
  }

  void changeFlashMode(FlashMode flashMode) async {
      setState(() => _currentFlashMode = flashMode);
      await controller!.setFlashMode(flashMode);
  }

  void showSettingsScreen(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(
        maxHeight: 792.0
      ),
      builder: (BuildContext context) => const CameraSettingsScreen()
    );
  }

  void onDoubleTap() => _isRecordingInProgress ? () async {
    if (controller!.value.isRecordingPaused) {
      await resumeVideoRecording();
    } else {
      await pauseVideoRecording();
    }
  } : changeSelectedCamera();

  void changeSelectedCamera() {
    if (widget.cameras.length < 2) return;
    setState(() => _isCameraInitialized = false);
    if (widget.cameras.length-1 > selectedCameraIndex) {
      selectedCameraIndex++;
    } else {
      selectedCameraIndex = 0;
    }
    onNewCameraSelected(widget.cameras[selectedCameraIndex]);
  }
  
  void onActionButtonPressed() => _isVideoCameraSelected ? () async {
      if (_isRecordingInProgress) {
        File videoFile = File((await stopVideoRecording())!.path);
        int currentUnix = DateTime.now().millisecondsSinceEpoch;
        final directory = await getApplicationDocumentsDirectory();
        String fileFormat = videoFile.path.split('.').last;
        _videoFile = await videoFile.copy('${directory.path}/$currentUnix.$fileFormat');
        _startVideoPlayer();
      } else {
        await startVideoRecording();
      }
      setState((){});
    } : () async {
      File imageFile = File((await takePicture())!.path);
      int currentUnix = DateTime.now().millisecondsSinceEpoch;
      final directory = await getApplicationDocumentsDirectory();
      String fileFormat = imageFile.path.split('.').last;
      log(fileFormat);
      await imageFile.copy('${directory.path}/$currentUnix.$fileFormat');
      refreshAlreadyCapturedImages();
      setState((){});
    };

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Size size = mediaQuery.size;
    final double deviceRatio = size.width / (size.height-mediaQuery.padding.vertical);
    const Color iconColor = Colors.white;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _isCameraPermissionGranted ? _isCameraInitialized
        ? Center(
          child: Column(
            children: [
              Stack(
                children: [
                  // ----------------------------------- //
                  AspectRatio(
                    aspectRatio: deviceRatio,
                    child: CameraPreview(controller!,
                      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints)
                      => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onDoubleTap: onDoubleTap,
                        onTapDown: (details) => onViewFinderTap(details, constraints))
                      )),
                  ),
                  // ----------------------------------- //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ----------------------------------- //
                        _TopBar(children: [
                          IconButton(icon: const Icon(Icons.settings, color: iconColor), onPressed: () => showSettingsScreen(context)),
                          _FlashButton(onPressed: changeFlashMode, color: iconColor, map: CameraData.flashMap),
                          if (widget.cameras.length > 1) IconButton(icon: const FaIcon(FontAwesomeIcons.arrowsRotate, color: iconColor), onPressed: changeSelectedCamera),
                          IconButton(icon: const Icon(Icons.close, color: iconColor), onPressed: ()=>Navigator.pop(context)),
                        ]),
                        // ----------------------------------- //
                        SizedBox(
                          height: size.height-mediaQuery.padding.vertical-64,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _ActionButton(
                                onPressed: onActionButtonPressed,
                                isVideoCameraSelected: _isVideoCameraSelected,
                                isRecordingInProgress: _isRecordingInProgress
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ) : const _Loading() : _PermissionDenied(onPressed: getPermissionStatus)
      )
    );
  }
}
// -------------------------------------------------- //
class _TopBar extends StatelessWidget {
  final List<Widget> children;

  const _TopBar({
    super.key,
    required this.children
  });

  @override
  Widget build(BuildContext context) => Align(alignment: Alignment.topCenter, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: children));
}
// -------------------------------------------------- //
class _ActionButton extends StatelessWidget {
  final void Function() onPressed;
  final bool isVideoCameraSelected, isRecordingInProgress;

  const _ActionButton({
    super.key,
    required this.onPressed,
    required this.isVideoCameraSelected,
    required this.isRecordingInProgress
  });

  @override
  Widget build(BuildContext context) => Center(child: InkWell(
    onTap: onPressed,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.circle, color: isVideoCameraSelected ? Colors.white : Colors.white38, size: 80),
        Icon(Icons.circle, color: isVideoCameraSelected ? Colors.red : Colors.white, size: 65),
        isVideoCameraSelected && isRecordingInProgress ? const Icon(Icons.stop_rounded, color: Colors.white, size: 32) : const SizedBox.shrink(),
      ])));
}
// -------------------------------------------------- //
class _Loading extends StatelessWidget {
  const _Loading({
    super.key
  });

  @override
  Widget build(BuildContext context) => Center(child: Text(Language.getLangPhrase(Phrase.loading), style: TextStyle(color: Theme.of(context).colorScheme.background)));
}

class _PermissionDenied extends StatelessWidget {
  final void Function() onPressed;

  const _PermissionDenied({
    super.key,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
     return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(Language.getLangPhrase(Phrase.permissionDenied), style: TextStyle(color: theme.colorScheme.background, fontSize: 24)),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(Language.getLangPhrase(Phrase.givePermission), style: TextStyle(color: theme.colorScheme.background, fontSize: 24)),
          ),
        ),
      ],
    );
  }
}

class _FlashButton extends StatefulWidget {
  final void Function(FlashMode flashMode) onPressed;
  final Color color;
  final Map<IconData, FlashMode> map;

  const _FlashButton({
    super.key,
    required this.onPressed,
    required this.color,
    required this.map
  });

  @override
  State<_FlashButton> createState() => _FlashButtonState();
}

class _FlashButtonState extends State<_FlashButton> {
  int selected = 0;
  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: () {
      selected < widget.map.length-1 ? selected++ : selected = 0;
      widget.onPressed(widget.map.values.elementAt(selected));
    },
    splashColor: Colors.transparent,
    icon: Icon(widget.map.keys.elementAt(selected), color: widget.color)
  );
}

class _MediaPreview extends StatefulWidget {
  const _MediaPreview({
    super.key
  });

  @override
  State<_MediaPreview> createState() => _MediaPreviewState();
}

class _MediaPreviewState extends State<_MediaPreview> {
  VideoPlayerController? videoController;
  File? _imageFile;
  @override
  Widget build(BuildContext context) => Container(
    width: 60, height: 60,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: Colors.white,
        width: 2
      ),
      image: _imageFile != null ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover) : null
    ),
    child: videoController != null && videoController!.value.isInitialized
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: AspectRatio(
                aspectRatio: videoController!.value.aspectRatio,
                child: VideoPlayer(videoController!)
            )
          )
        : Container()
  );
}



// Padding(
//   padding: const EdgeInsets.only(right: 8.0, top: 16.0),
//   child: Container(
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius:
//       BorderRadius.circular(10.0),
//     ),
//     child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text(
//         '${_currentExposureOffset.toStringAsFixed(1)}x',
//         style: const TextStyle(color: Colors.black),
//       ),
//     ),
//   ),
// ),
// Expanded(
//   child: RotatedBox(
//     quarterTurns: 3,
//     child: SizedBox(
//       height: 30,
//       child: Slider(
//         value: _currentExposureOffset,
//         min: _minAvailableExposureOffset,
//         max: _maxAvailableExposureOffset,
//         activeColor: Colors.white,
//         inactiveColor: Colors.white30,
//         onChanged: (value) async {
//           setState(()=>_currentExposureOffset = value);
//           await controller!.setExposureOffset(value);
//         },
//       ),
//     ),
//   ),
// ),
// Row(
//   children: [
//     Expanded(
//       child: Slider(
//         value: _currentZoomLevel,
//         min: _minAvailableZoom,
//         max: _maxAvailableZoom,
//         activeColor: Colors.white,
//         inactiveColor: Colors.white30,
//         onChanged: (value) async {
//           setState(()=>_currentZoomLevel = value);
//           await controller!.setZoomLevel(value);
//         },
//       ),
//     ),
//     Padding(
//       padding:
//       const EdgeInsets.only(right: 8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.black87,
//           borderRadius:
//           BorderRadius.circular(10.0),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text('${_currentZoomLevel.toStringAsFixed(1)}x',
//             style: const TextStyle(color: Colors.white),
//           ),
//         ),
//       ),
//     ),
//   ],
// ),
// Expanded(
//   child: SingleChildScrollView(
//     physics: const BouncingScrollPhysics(),
//     child: Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 8.0, right: 4.0),
//                   child: TextButton(
//                     onPressed: _isRecordingInProgress ? null : () {if (_isVideoCameraSelected) setState(()=>_isVideoCameraSelected=false);},
//                     style: TextButton.styleFrom(
//                       foregroundColor: _isVideoCameraSelected ? Colors.black54 : Colors.black,
//                       backgroundColor: _isVideoCameraSelected ? Colors.white30 : Colors.white,
//                     ),
//                     child: Text(Language.getLangPhrase(Phrase.image)),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 4.0, right: 8.0),
//                   child: TextButton(
//                     onPressed: () {
//                       if (!_isVideoCameraSelected) setState(()=>_isVideoCameraSelected=true);
//                     },
//                     style: TextButton.styleFrom(
//                       foregroundColor: _isVideoCameraSelected  ? Colors.black : Colors.black54,
//                       backgroundColor: _isVideoCameraSelected ? Colors.white : Colors.white30,
//                     ),
//                     child: Text(Language.getLangPhrase(Phrase.video))
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   ),
// ),
