import 'package:flutter/material.dart';

import '../../../language/language.dart';

class SnapshotHandler extends StatelessWidget {
  final BuildContext context;
  final AsyncSnapshot snapshot;
  final Widget onSuccess;
  final bool inCenterErrorInfo;

  const SnapshotHandler({
    super.key,
    required this.context,
    required this.snapshot,
    required this.onSuccess,
    this.inCenterErrorInfo = false
  });

  static Widget handleSnapshot(BuildContext context, AsyncSnapshot snapshot, Widget onSuccess) =>
    SnapshotHandler(context: context, snapshot: snapshot, onSuccess: onSuccess);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      return onSuccess;
    } else if (snapshot.hasError) {
      Color errorColor = Theme.of(context).colorScheme.error;
      Widget errorWidget = Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48.0, color: errorColor),
            Text(Language.getLangPhrase(Phrase.error), style: TextStyle(color: errorColor, fontSize: 22.0))
          ]
        )
      );
      return !inCenterErrorInfo ? errorWidget : Center(child: errorWidget);
    } else {
      return const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 48.0), child: CircularProgressIndicator()));
    }
  }
}
