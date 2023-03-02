import 'package:flutter/material.dart';
import 'package:frontend/launch/routes/app_router.dart';
import 'package:frontend/service/services.dart';

import '../../../language/language.dart';
import '../../../launch/navigator/app_navigator.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key
  });
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * .85,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 0.0),
        children: <Widget>[
          const TopBar(),
          // Tile(const Icon(Icons.person_search), Language.getLangPhrase(Phrase.searchFriends), () => Navigator.popAndPushNamed(context, AppRouter.searchFriendsRoute)),
          Tile(const Icon(Icons.add), Language.getLangPhrase(Phrase.create), () => Navigator.popAndPushNamed(context, AppRouter.createRoute)),
          // Tile(const Icon(Icons.groups_outlined), Language.getLangPhrase(Phrase.groups), () => Navigator.popAndPushNamed(context, AppRouter.groupsRoute)),
          // Tile(const Icon(Icons.tv), Language.getLangPhrase(Phrase.films), ()=>Navigator.pop(context)), // TODO
          // Tile(const Icon(Icons.bookmark), Language.getLangPhrase(Phrase.saved), ()=>Navigator.pop(context)), // TODO
          // Tile(const Icon(Icons.pageview_outlined), Language.getLangPhrase(Phrase.pages), ()=>Navigator.popAndPushNamed(context, '/pages/')),
          // Tile(const Icon(Icons.movie_outlined), Language.getLangPhrase(Phrase.reels), ()=>Navigator.pop(context)), // TODO
          // Tile(const Icon(Icons.event_outlined), Language.getLangPhrase(Phrase.events), ()=>Navigator.popAndPushNamed(context, '/events/')),
          // Tile(const Icon(Icons.cloud), Language.getLangPhrase(Phrase.weather), ()=>Navigator.pop(context)), // TODO
          // Tile(const Icon(Icons.amp_stories), Language.getLangPhrase(Phrase.stories), ()=>Navigator.popAndPushNamed(context, '/stories/')),
          // Tile(const Icon(Icons.live_tv), Language.getLangPhrase(Phrase.lives), ()=>Navigator.pop(context)), // TODO
          // Tile(const Icon(Icons.help_center), Language.getLangPhrase(Phrase.helpCenter), ()=>Navigator.pop(context)), // TODO
          // Tile(const Icon(Icons.warning), Language.getLangPhrase(Phrase.reportProblem), ()=>Navigator.pop(context)), // TODO
          // Tile(const Icon(Icons.shield_outlined), Language.getLangPhrase(Phrase.security), ()=>Navigator.pop(context)), // TODO
          Tile(const Icon(Icons.book), Language.getLangPhrase(Phrase.rules), () => Navigator.popAndPushNamed(context, AppRouter.rulesRoute)),
          Tile(const Icon(Icons.supervised_user_circle_outlined), Language.getLangPhrase(Phrase.switchUser), () => Navigator.popAndPushNamed(context, AppRouter.switchUserRoute)),
          Tile(const Icon(Icons.exit_to_app), Language.getLangPhrase(Phrase.logout), () => Services.securityService.logout().whenComplete(() => AppNavigator.of(context).popAllAndPushNamed(AppRouter.loginRoute)))
        ],
      )
    );
  }
}

class Tile extends StatelessWidget {
  final Icon icon;
  final String title;
  final void Function() onTap;

  const Tile(
    this.icon,
    this.title,
    this.onTap,
    {super.key}
  );

  @override
  Widget build(BuildContext context) => ListTile(
    leading: icon,
    title: Text(title),
    onTap: onTap
  );
}

class TopBar extends StatelessWidget {
  const TopBar({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Language.getLangPhrase(Phrase.menu),
            style: const TextStyle(
              fontSize: 25.0
            )
          ),
          Row(children: [
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => Navigator.popAndPushNamed(context, AppRouter.settingsRoute)
            ),
            IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context)
            )
          ])
        ],
      ),
    );
  }
}
