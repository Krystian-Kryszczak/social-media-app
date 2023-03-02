import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../../language/language.dart';
import '../../../../../../launch/routes/app_router.dart';
import '../../../../../widget/operations/edit/edit_bar.dart';
import '../../../../../widget/operations/media/media_preview.dart';
import '../../../../../widget/operations/publish/publish_app_bar.dart';

class PostEditorScreen extends StatelessWidget { // Actually it looks like image edit screen // <-----
  const PostEditorScreen({
    super.key
  });
  
  @override
  Widget build(BuildContext context) {
    final List<File> media = ModalRoute.of(context)!.settings.arguments as List<File>;

    List<File> completed = [];
    void navToFinalize(BuildContext context) => Navigator.pushNamed(context, AppRouter.finalizeLookRoute, arguments: completed);

    void onEditComplete(List<File> onCompletedList) {
      if (onCompletedList.isNotEmpty) {
        // TODO
      }
    }

    return _Editor(media: media, onComplete: onEditComplete, navToFinalize: navToFinalize);
  }
}

class _Editor extends StatefulWidget {
  final List<File> media;
  final void Function(List<File>) onComplete;
  final void Function(BuildContext) navToFinalize;

  const _Editor({
    super.key,
    required this.media,
    required this.onComplete,
    required this.navToFinalize
  });

  @override
  State<_Editor> createState() => _EditorState();
}

class _EditorState extends State<_Editor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PublishAppBar(
        onPressed: () => widget.navToFinalize(context),
        title: Text(Language.getLangPhrase(Phrase.edit)),
        iconColor: Theme.of(context).colorScheme.secondary
      ),
      body: IndexedStack(
        children: [
          MediaPreview(media: widget.media.first),
          MediaPreview(media: widget.media.first)
        ],
      ),
      bottomNavigationBar: EditBar(image: Image.file(widget.media.first)),
    );
  }
}
