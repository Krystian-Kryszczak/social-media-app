import 'dart:io';

class MediaService {
  static bool fileIsMedia({File? file, String? path}) => fileIsVideo(file: file, path: path) || fileIsImage(file: file, path: path) || fileIsAudio(file: file, path: path);
  // -------------------------------------------------- //
  static bool fileIsVideo({File? file, String? path}) => (path??file?.path??'').contains(RegExp('.mp4|.mov'));
  static bool fileIsImage({File? file, String? path}) => (path??file?.path??'').contains(RegExp('.jpg|.png|.jpeg'));
  static bool fileIsAudio({File? file, String? path}) => (path??file?.path??'').contains(RegExp('.mp3|.wav|.ogg'));
  // -------------------------------------------------- //
  static bool fileIsVisible({File? file, String? path}) => fileIsVideo(file: file, path: path) || fileIsImage(file: file, path: path);
  static bool fileIsStreamable({File? file, String? path}) => fileIsVideo(file: file, path: path) || fileIsAudio(file: file, path: path);
}
