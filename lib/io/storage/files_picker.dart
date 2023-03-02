import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class FilesPicker {
  static final ImagePicker _imagePicker = ImagePicker();
  static Future<File?> pickSingleFile() async => FilePicker.platform.pickFiles().then((result) => (result!=null ? (result.files.single.path!=null ? File(result.files.single.path??'') : null) : null));
  static Future<List<File>?> pickFiles({FileType type = FileType.any, List<String>? allowedExtensions}) async => FilePicker.platform.pickFiles(allowMultiple: true, type: type, allowedExtensions: allowedExtensions).then((result) {
    if (result!=null) {
      List<File> list = result.paths.map((path) => path!=null&&path.isNotEmpty ? File(path) : null).skipWhile((file) => file==null).toList().cast();
      return list.isNotEmpty ? list : null;
    }
    return null;
  });
  static Future<List<File>?> pickMedia({FileType type = FileType.any}) async => !kIsWeb
    ? pickFiles(type: type)
    : _imagePicker.pickMultiImage().then((list) => list.map((e) => File(e.path)).toList());
}
