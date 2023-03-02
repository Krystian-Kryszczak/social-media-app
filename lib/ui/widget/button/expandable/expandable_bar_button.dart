import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../language/language.dart';
import '../../../../launch/routes/app_router.dart';
import '../action/action_button.dart';

List<Widget> expandingActionButtons(BuildContext context) => [
  ActionButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.pushNamed(context, AppRouter.settingsRoute)),
  ActionButton(icon: const Icon(Icons.add_box_outlined), onPressed: () => Navigator.pushNamed(context, AppRouter.createRoute)),
  // ActionButton(icon: const Icon(Icons.search), onPressed: () => Navigator.pushNamed(context, AppRouter.searchRoute)),
  // ActionButton(icon: const Icon(Icons.camera), onPressed: () => Navigator.pushNamed(context, AppRouter.cameraRoute)),
  ActionButton(icon: const Icon(Icons.person), onPressed: () => Navigator.pushNamed(context, AppRouter.profileRoute)),
];

class ExpandableBarButton extends StatefulWidget {
  final double size;
  final AnimatedIconData icon;
  final double distance;
  final List<Widget>? children;
  final double iconSize;

  const ExpandableBarButton({
    Key? key,
    required this.size,
    this.icon = AnimatedIcons.menu_close,
    this.iconSize = 30,
    this.distance = 112.0,
    this.children
  }) : super(key: key);

  @override
  State<ExpandableBarButton> createState() => _ExpandableBarButtonState();
}

class _ExpandableBarButtonState extends State<ExpandableBarButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  bool _open = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(value: _open ? 1.0 : 0.0, duration: const Duration(milliseconds: 500), vsync: this);
    _expandAnimation = CurvedAnimation(curve: Curves.fastOutSlowIn, reverseCurve: Curves.easeOutQuad, parent: _controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() => setState(() {
    (_open=!_open) ? _controller.forward() : _controller.reverse();
  });

  @override
  Widget build(BuildContext context) {
    final double size = widget.distance*1.5;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        SizedBox(width: size, height: size),
        ..._buildExpandingActionButtons(context),
        _Button(size: widget.size, iconData: widget.icon, iconSize: widget.iconSize, onPressed: _toggle),
      ],
    );
  }

  List<Widget> _buildExpandingActionButtons(BuildContext context) {
    final children = <Widget>[];
    final widgetChildren = widget.children ?? expandingActionButtons(context);
    final count = widgetChildren.length;
    final step = 90.0 / (count - 1);

    for (var i = 0, angleInDegrees = 0.0; i < count; i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widgetChildren[i],
        ),
      );
    }
    return children;
  }
}

class _Button extends StatefulWidget {
  final double size;
  final AnimatedIconData iconData;
  final double iconSize;
  final void Function() onPressed;

  const _Button({
    Key? key,
    required this.size,
    required this.iconData,
    required this.iconSize,
    required this.onPressed
  }) : super(key: key);

  @override
  State<_Button> createState() => _ButtonState();
}

class _ButtonState extends State<_Button> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      width: widget.size, height: widget.size,
      color: theme.colorScheme.primary,
      child: IconButton(
        icon: AnimatedIcon(
          icon: widget.iconData,
          progress: _controller,
          semanticLabel: Language().getTranslation(Phrase.showMenu)
        ),
        iconSize: widget.iconSize,
        onPressed: () {
          (_open = !_open) ? _controller.forward() : _controller.reverse();
          widget.onPressed();
        },
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(directionInDegrees * (pi / 180.0), progress.value * maxDistance);
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * pi / 2,
            child: child
          )
        );
      },
      child: FadeTransition(opacity: progress, child: child),
    );
  }
}
