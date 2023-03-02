import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/service/services.dart';

import '../../../../../language/language.dart';
import '../../../../../launch/navigator/app_navigator.dart';
import '../../../../../launch/routes/app_router.dart';
import '../../../../widget/operations/form/text_area.dart';
import '../../../../widget/operations/publish/publish_app_bar.dart';

class WatchFinalizerScreen extends StatefulWidget {
  const WatchFinalizerScreen({
    super.key
  });

  @override
  State<WatchFinalizerScreen> createState() => _WatchFinalizerScreenState();
}

class _WatchFinalizerScreenState extends State<WatchFinalizerScreen> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController(text: dotenv.maybeGet('TESTING_WATCH_FORM_VALUE'));
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<File> args = ModalRoute.of(context)!.settings.arguments as List<File>;
    ThemeData theme = Theme.of(context);
    const double imageBasis = 72.0;
    const double dividerHeight = 8.0;
    const EdgeInsets padding = EdgeInsets.all(8.0);
    return Scaffold(
      appBar: PublishAppBar(onPressed: () => publish(context, textEditingController.text, 'Hello world!',  false, args.first, null), title: Text(Language.getLangPhrase(Phrase.newWatch)), iconColor: Theme.of(context).colorScheme.primary, finalize: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: padding,
            child: SizedBox(
              height: imageBasis,
              child: Row(
                children: [
                  SizedBox(
                    width: imageBasis, height: imageBasis,
                    child: Container(
                      color: theme.cardColor,
                      child: Image.file(args.first),
                    ),
                  ),
                  Expanded(
                    child: TextArea(
                      controller: textEditingController,
                      hintText: Language.getLangPhrase(Phrase.addCaption),
                    )
                  )
                ],
              ),
            ),
          ),
          const Divider(height: dividerHeight),
          _LabelButton(label: Language.getLangPhrase(Phrase.tagPeople), onTap: tagPeople),
          const Divider(height: dividerHeight),
          _LabelButton(label: Language.getLangPhrase(Phrase.addLocation), onTap: addLocation),
          const Divider(height: dividerHeight),
          _LabelButton(label: Language.getLangPhrase(Phrase.advancedSettings), onTap: advancedSettings, hasArrow: true),
        ],
      ),
    );
  }
  void publish(BuildContext context, String title, String description, bool private, File content, File? miniature) async {
    Services.watchService.add(title, description, content, miniature, private).onError((error, stackTrace) {
      log(error.toString());
      log(stackTrace.toString());
      return null;
    }).then((id) {
      ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
      AppNavigator.of(context).popAllAndPushNamed(AppRouter.homeRoute)
        .then((_) => messenger.showSnackBar(
          SnackBar(
            content: Text(id != null ? '${Language.getLangPhrase(Phrase.watchSuccessfullyUploaded)} (id: $id)' : Language.getLangPhrase(Phrase.watchUploadFailed)),
            action: SnackBarAction(
              label: Language.getLangPhrase(Phrase.ok),
              onPressed: () => messenger.hideCurrentSnackBar(),
            ),
          )
        )
      );
    });
  }

  void tagPeople() {
    //
  }

  void addLocation() {
    //
  }

  void advancedSettings() {
    //
  }
}

class _LabelButton extends StatelessWidget {
  final String label; final void Function() onTap; final bool hasArrow;
  const _LabelButton({Key? key, required this.label, required this.onTap, this.hasArrow = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              if (hasArrow) const Icon(Icons.keyboard_arrow_right),
            ],
          )
        ),
      ),
    );
  }
}
