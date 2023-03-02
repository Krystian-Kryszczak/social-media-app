import 'package:flutter/material.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).colorScheme.onBackground.withOpacity(.065),
      )
    );
  }
}
