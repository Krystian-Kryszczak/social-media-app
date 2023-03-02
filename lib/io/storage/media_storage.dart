import 'package:flutter/material.dart';

class MediaStorage {
  static Image getLocalImage({required String url}) => Image(image: AssetImage(url));
}
