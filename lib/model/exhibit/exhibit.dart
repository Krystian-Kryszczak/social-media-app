import 'package:flutter/cupertino.dart';
import 'package:frontend/io/network/endpoints.dart';
import 'package:frontend/io/storage/network_files.dart';
import 'package:frontend/model/being/user/user.dart';
import 'package:frontend/model/exhibit/votable.dart';

import 'package:rxdart/rxdart.dart';
import '../url_access.dart';

enum CommentsSort { mostRelevant, latest, all }
abstract class Exhibit extends Votable implements UrlAccess { // TODO
  final String name;
  final String? creatorId;
  final String? creatorName;
  int creatorSubscriptions;
  final int views;
  final bool private;

  Exhibit({
    super.id,
    required this.name,
    this.creatorId,
    this.creatorName,
    this.creatorSubscriptions = 0,
    this.views = 0,
    super.rating = 0,
    required this.private
  });

  DateTime get dateOfPublication => DateTime.now();
  ImageProvider get _creatorAvatarImageProvider => NetworkFiles.getImageProvider(url: Endpoints.images + creatorId!);
  Widget get creatorAvatarImageWidget => NetworkFiles.getNetworkImage(url: Endpoints.images + creatorId!, fit: BoxFit.cover, fallback: const Image(image: User.defaultAvatarImg, fit: BoxFit.cover));
  
  // TODO comments

  int commentsOffset = -1;
  Stream<String> getComments({CommentsSort sortBy = CommentsSort.all}) async* {
    Rx.range(1, 5); // TODO
  }
  Future<bool> addComment(String comment) {
    // list.add(comment);
    return Future(() => false);
  }
}
