import 'package:flutter/material.dart';

import 'package:frontend/model/being/user/user.dart';
import 'package:frontend/service/services.dart';
import 'package:frontend/service/user/user_service.dart';
import 'package:frontend/ui/widget/snapshot/snapshot_handler.dart';

import '../../../language/language.dart';
import '../../../launch/routes/app_router.dart';

class SwitchUser extends StatefulWidget {
  const SwitchUser({
    super.key
  });

  @override
  State<SwitchUser> createState() => _SwitchUserState();
}

class _SwitchUserState extends State<SwitchUser> {
  // static const Widget separator = SizedBox(height: 20);
  UserService userService = Services.userService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                Language.getLangPhrase(Phrase.switchUser),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              )
            ),
            const SizedBox(height: 60),
            FutureBuilder(
              future: userService.currentUser.timeout(const Duration(seconds: 15)),
              builder: (context, snapshot) => SnapshotHandler(context: context, snapshot: snapshot,
                onSuccess: InkWell(
                  onTap: () {
                    // TODO
                  },
                  splashColor: Colors.blue,
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 1.0),
                        borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(backgroundImage: snapshot.data?.avatarImage ?? User.defaultAvatarImg),
                        const SizedBox(width: 8.0),
                        Text(
                          snapshot.data?.name ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        IconButton(onPressed: () => Navigator.pushNamed(context, AppRouter.switchUserRoute), icon: const Icon(Icons.more_horiz))
                      ],
                    ),
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
