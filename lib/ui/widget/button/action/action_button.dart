import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Widget icon;
  final void Function() onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) => Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.none,
      elevation: 4.0,
      child: IconButton(
          icon: icon,
          onPressed: onPressed
      )
  );
}
