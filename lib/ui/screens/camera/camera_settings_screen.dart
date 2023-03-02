import 'package:flutter/material.dart';

class CameraSettingsScreen extends StatelessWidget {
  const CameraSettingsScreen({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: size.width,
        // height: size.height,
        color: Colors.black
      )
    );
  }
}
