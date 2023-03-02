import 'package:flutter/material.dart';
import 'package:frontend/extension/datetime/datetime_formatter.dart';
import 'package:frontend/extension/views/views_formatter.dart';
import 'package:frontend/launch/routes/app_router.dart';
import 'package:frontend/ui/widget/image/app_circle_avatar.dart';

import '../../../../language/language.dart';
import '../../../../model/exhibit/watch/watch.dart';

class WatchItem extends StatelessWidget {
  final Watch watch;

  const WatchItem({
    super.key,
    required this.watch
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRouter.watchPlayerRoute, arguments: watch),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16/9,
              child: watch.getMiniatureImage(context),
            ),
            WatchDetails(watch: watch)
          ],
        ),
      ),
    );
  }
}

class WatchDetails extends StatelessWidget {
  final Watch watch;

  const WatchDetails({
    super.key,
    required this.watch
  });

  @override
  Widget build(BuildContext context) {
    TextStyle descriptionTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.onSurface
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 8.0),
          AppCircleAvatar(avatar: watch.creatorAvatarImageWidget),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  watch.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 4.0),
                Wrap(
                  runAlignment: WrapAlignment.start,
                  children: [
                    Text(watch.creatorName ?? Language.getLangPhrase(Phrase.lackOfInfo), style: descriptionTextStyle),
                    Text('  ·  ', style: descriptionTextStyle),
                    Text(watch.views.formatCount(), style: descriptionTextStyle),
                    Text('  ·  ', style: descriptionTextStyle),
                    Text(watch.dateOfPublication.formatDateTimeAgo(), style: descriptionTextStyle)
                  ],
                )
              ],
            )
          ),
          const SizedBox(width: 8.0),
          Column(
            children: [
              InkWell(
                child: const Icon(Icons.more_vert, size: 18.0),
                onTap: () {
                  //
                }
              ),
              const SizedBox(height: 18.0),
            ],
          ),
          const SizedBox(width: 4.0)
        ],
      ),
    );
  }
}
