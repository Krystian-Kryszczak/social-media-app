import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/ui/screens/camera/camera_screen.dart';
import 'package:frontend/ui/screens/create/select/publish/publish_overlay.dart';

import '../../../../io/camera/camera.dart';
import '../../../../language/language.dart';
import '../../../../launch/routes/app_router.dart';
import 'camera/camera_overlay.dart';

class CreateOverlayData {
  final String label;
  final Widget? widget;
  final List<Widget> sideBarOptions;

  CreateOverlayData(
    this.label, {
    this.sideBarOptions = const [],
    this.widget
  });
}

Map<String, CreateOverlayData> _overlays = {
  AppRouter.createWatchRoute: CreateOverlayData(
      Language.getLangPhrase(Phrase.watchOverlay),
      widget: PublishOverlay(
          title: Language.getLangPhrase(Phrase.newWatch),
          fileType: FileType.video,
          nextStepRoute: AppRouter.finalizeWatchRoute
      )
  ),
  AppRouter.createLookRoute: CreateOverlayData(
      Language.getLangPhrase(Phrase.lookOverlay),
      widget: SizedBox( // without sized box it's not work correct (not will changing)
        child: PublishOverlay(
          title: Language.getLangPhrase(Phrase.newLook),
          fileType: FileType.image,
          nextStepRoute: AppRouter.finalizeLookRoute
        ),
      )
  ),
};

final CameraScreen _camera = CameraData.getCamera();

class CreateScreen extends StatefulWidget {
  final String initialRoute;

  const CreateScreen({
    super.key,
    this.initialRoute = AppRouter.watch
  });

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  late Widget overlay;

  @override
  void initState() {
    super.initState();
    CreateOverlayData overlayData = _overlays[widget.initialRoute] ?? _overlays.values.elementAt(0);
    overlay = overlayData.widget ?? ((Platform.isAndroid || Platform.isIOS) ? CameraOverlay(camera: _camera) : const Scaffold());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: overlay,
      bottomNavigationBar: _NavigatorCarousel(
        route: widget.initialRoute,
        changeOverlay: (index) {
          CreateOverlayData overlayData = _overlays.values.elementAt(index);
          Widget? widget = overlayData.widget;
          if (widget != null) {
            setState(() => overlay = widget);
          } else {
            setState(() => overlay = CameraOverlay(camera: _camera));
          }
        }
      ),
      extendBody: true
    );
  }
}

class _NavigatorCarousel extends StatefulWidget {
  final String route;
  final void Function(int index) changeOverlay;

  const _NavigatorCarousel({
    super.key,
    required this.route,
    required this.changeOverlay
  });

  @override
  State<_NavigatorCarousel> createState() => _NavigatorCarouselState();
}

class _NavigatorCarouselState extends State<_NavigatorCarousel> {
  PageController controller = PageController(viewportFraction: .275);
  late int selected;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    selected = (){
      for (int i=0; i < _overlays.length; i++) {
        if (widget.route == _overlays.keys.elementAt(i)) return i;
      }
      return 0;
    }();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    widget.changeOverlay(index);
    setState(() => selected = index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 50.0,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: PageView.builder(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          pageSnapping: true,
          onPageChanged: onPageChanged,
          itemCount: _overlays.length,
          itemBuilder: (context, index) => _NavigatorItem(
            data: _overlays.values.elementAt(index).label,
            onPressed: () => controller.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.linearToEaseOut),
            isActive: index == selected,
            pos: (index == 0 ? true : (index == _overlays.length-1 ? false : null))
          )
        ),
      ),
    );
  }
}

class _NavigatorItem extends StatelessWidget {
  final String data;
  final void Function() onPressed;
  final bool isActive;
  final bool? pos;

  const _NavigatorItem({
    super.key,
    required this.data,
    required this.onPressed,
    this.isActive = false,
    this.pos
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius? borderRadius;
    if (pos != null) {
      borderRadius = (pos!)
        ? const BorderRadius.horizontal(left: Radius.circular(30.0))
        : const BorderRadius.horizontal(right: Radius.circular(30.0));
    }

    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: borderRadius
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Center(
          child: Text(
            data.toUpperCase(),
            maxLines: 1,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.black45,
              fontSize: 16.0,
              fontWeight: FontWeight.bold
            )
          )
        )
      ),
    );
  }
}
