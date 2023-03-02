import 'package:flutter/material.dart';

class AppCircleAvatar extends StatelessWidget {
  final Widget avatar;

  const AppCircleAvatar({
    super.key,
    required this.avatar
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 34.0,
        height: 34.0,
        child: avatar,
      ),
    );
  }
}
