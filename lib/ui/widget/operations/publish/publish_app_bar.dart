import 'package:flutter/material.dart';

import '../../../style/palette/palette.dart';

class PublishAppBar extends AppBar {
  PublishAppBar({
    super.key,
    required VoidCallback onPressed,
    super.title,
    super.centerTitle = false,
    Color iconColor = Palette.primaryColor,
    bool finalize = false
  }) : super(
    shadowColor: Colors.transparent,
    actions: [
      IconButton(
        icon: Icon(!finalize ? Icons.arrow_forward : Icons.done),
        color: iconColor,
        onPressed: onPressed
      )
    ],
  );
}
