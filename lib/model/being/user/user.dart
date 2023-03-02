import 'package:flutter/widgets.dart';
import 'package:frontend/io/network/endpoints.dart';
import 'package:frontend/io/storage/network_files.dart';

import '../being.dart';

class User extends Being {
  static const ImageProvider defaultAvatarImg = AssetImage('./assets/media/images/user/user_placeholder.png');

  final String lastname;

  User({
    super.id,
    required super.name,
    required this.lastname
  });

  static String getAvatarUrlForUserWithId({required String? id}) => id != null ? Endpoints.images + id: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/480px-User-avatar.svg.png';
  static ImageProvider getAvatarImageForUserWithId({required String? id}) => (id != null && id.isNotEmpty) ? NetworkFiles.getImageProvider(url: Endpoints.images + id) : defaultAvatarImg;
  static Widget getCreatorAvatarImageWidgetForUserWithId({required String? id}) => NetworkFiles.getNetworkImage(url: Endpoints.images + id!, fit: BoxFit.cover, fallback: const Image(image: User.defaultAvatarImg, fit: BoxFit.cover));

  String getAvatarUrl() => getAvatarUrlForUserWithId(id: id);
  ImageProvider get avatarImage => getAvatarImageForUserWithId(id: id);
  Widget get avatarImageWidget => getCreatorAvatarImageWidgetForUserWithId(id: id);

  ImageProvider getAvatarImage() {
    if ((id != null && id!.isNotEmpty)) {
      return NetworkFiles.getImageProvider(url: Endpoints.images + id!);
    } else {
      return defaultAvatarImg;
    }
  }

  factory User.formJson(Map<String, dynamic> data) {
    final id = data['id'] as String?;
    final name = data['name'] as String;
    final lastname = data['lastname'] as String;
    return User(id: id, name: name, lastname: lastname);
  }
}
