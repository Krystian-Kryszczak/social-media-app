import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/extension/datetime/datetime_formatter.dart';
import 'package:frontend/model/exhibit/watch/watch.dart';
import 'package:frontend/ui/widget/exhibit/watch/watch_player_frame.dart';
import 'package:frontend/ui/widget/image/app_circle_avatar.dart';

import '../../../language/language.dart';

class WatchPlayer extends StatelessWidget {
  const WatchPlayer({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final watch = ModalRoute.of(context)!.settings.arguments as Watch;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            bottom: false,
            child: WatchPlayerFrame(watch: watch),
          ),
          const SizedBox(height: 12.0),
          _WatchTitle(watch: watch),
          _WatchDetails(watch: watch),
          _WatchAuthor(watch: watch),
          _WatchOperations(watch: watch),
          _WatchComments(watch: watch),
          _WatchNext(watch: watch)
        ],
      ),
    );
  }
}

class _WatchTitle extends StatelessWidget {
  final Watch watch;

  const _WatchTitle({
    super.key,
    required this.watch,
  });

  @override
  Widget build(BuildContext context) {
    return _Padding(
      child: Text(
        watch.name,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _WatchDetails extends StatelessWidget {
  final Watch watch;

  const _WatchDetails({
    super.key,
    required this.watch,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      textStyle: const TextStyle(
        fontSize: 12.8,
        fontWeight: FontWeight.w500,
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Details //
            _Padding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: Colors.transparent,
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground.withAlpha(145),
                      overflow: TextOverflow.ellipsis
                    ),
                    child: Row(
                      children: [
                        // Views //
                        Text('${watch.views} ${Language.getLangPhrase(Phrase.views)}'),

                        // Separator //
                        const _Separator(),

                        // Added Time //
                        Text(watch.dateOfPublication.formatDateTimeAgo()),

                        // Separator //
                        const _Separator(),

                        // Description //
                        Text(watch.description)
                      ],
                    ),
                  ),
                  InkWell(
                    child: Text(' ...${Language.getLangPhrase(Phrase.more).toLowerCase()}'),
                    onTap: () {
                      log('Show description!');
                    },
                  )
                ],
              ),
            ),
          ],
        ),
    );
  }
}

class _WatchAuthor extends StatelessWidget {
  final Watch watch;

  const _WatchAuthor({
    super.key,
    required this.watch,
  });

  @override
  Widget build(BuildContext context) {
    return _Padding(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AppCircleAvatar(avatar: watch.creatorAvatarImageWidget),
              const SizedBox(width: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    watch.creatorName ?? Language.getLangPhrase(Phrase.lackOfInfo),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    '${watch.creatorSubscriptions} ${Language.getLangPhrase(Phrase.subscriptions).toLowerCase()}',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Theme.of(context).colorScheme.onBackground.withAlpha(125)
                    ),
                  )
                ],
              )
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
            child: Text(
              Language.getLangPhrase(Phrase.subscribe),
              style: const TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      )
    );
  }
}

class _WatchOperations extends StatelessWidget {
  final Watch watch;

  const _WatchOperations({
    super.key,
    required this.watch,
  });

  @override
  Widget build(BuildContext context) {
    const double spaceBetween = 12.0;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 12.0),
          RawChip(
            label: Row(
              children: [
                InkWell(
                  child: const Icon(Icons.keyboard_arrow_up),
                  onTap: () {},
                ),
                const SizedBox(width: 4.0),
                Text(watch.rating.toString()),
                const SizedBox(width: 4.0),
                InkWell(
                  child: const Icon(Icons.keyboard_arrow_down),
                  onTap: () {},
                ),
              ],
            )
          ),
          const SizedBox(width: spaceBetween),
          RawChip(
            label: Row(
              children: [
                Transform.scale(
                  scaleX: -1,
                  child: const Icon(
                    Icons.reply,
                    size: 18.0,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(Language.getLangPhrase(Phrase.share))
              ],
            ),
          ),
          const SizedBox(width: 12.0),
        ],
      ),
    );
  }
}

class _WatchComments extends StatelessWidget {
  final Watch watch;

  const _WatchComments({
    super.key,
    required this.watch,
  });

  @override
  Widget build(BuildContext context) {
    return _Padding(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(8.0))
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  Language.getLangPhrase(Phrase.comments),
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(width: 8.0),
                const Text('0')
              ],
            ),
          ],
        ),
      )
    );
  }
}

class _WatchNext extends StatelessWidget {
  final Watch watch;

  const _WatchNext({
    super.key,
    required this.watch,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _Separator extends StatelessWidget {
  const _Separator({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      '  ·  ', style: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w900
      ),
    );
  }
}

class _Padding extends StatelessWidget {
  final Widget child;

  const _Padding({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 6.0
      ),
      child: child
    );
  }
}
