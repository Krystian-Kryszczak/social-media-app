import 'package:flutter/material.dart';
import 'package:frontend/service/services.dart';
import 'package:frontend/service/user/user_service.dart';
import 'package:frontend/ui/widget/progress/app_progress_indicator.dart';
import 'package:frontend/ui/widget/snapshot/snapshot_handler.dart';

import '../../../model/being/user/user.dart';

UserService userService = Services.userService;
class UserProfileScreen extends StatelessWidget {
  final User? user;
  
  const UserProfileScreen({
    super.key,
    this.user
  });

  @override
  Widget build(BuildContext context) {
    Future<User?> user = Future(() => this.user);
    if (this.user == null) {
      Object? arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments != null) {
        if (arguments is User) {
          user = Future(() => this.user);
        } else if (arguments is String) {
          user = userService.findById(arguments);
        }
      }
    }

    return Scaffold(
      body: Column(
        children: [
          const Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  FutureBuilder(
                    future: user,
                    builder: (context, snapshot) => SnapshotHandler(context: context, snapshot: snapshot,
                      onSuccess: () {
                        User? user = snapshot.data;
                        return user != null ? Text(
                          '${user.name} ${user.lastname}',
                          style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        ) : const AppProgressIndicator();
                      } ()
                    )
                  ),
                  const SizedBox(height: 16),
                  const _ProfileInfoRow()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final User? user;

  const _ProfileInfoRow({
    super.key,
    this.user
  });

  @override
  Widget build(BuildContext context) {
    const Map<String, int> items = {
      "Posts": 900,
      "Followers": 120,
      "Following": 200,
    };

    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items
          .map((key, value) => MapEntry(key, Expanded(
            child: Row(
              children: [
                if (key != items.keys.first) const VerticalDivider(),
                Expanded(child: _singleItem(context, key, value)),
              ],
            )))
          ).values.toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, String title, int value) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          value.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      Text(
        title,
        style: Theme.of(context).textTheme.caption,
      )
    ],
  );
}

class _TopPortion extends StatelessWidget {
  final User? user;

  const _TopPortion({
    super.key,
    this.user
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    theme.colorScheme.primary,
                    const Color(0xff000c17)
                  ]),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(-50),
                bottomRight: Radius.circular(-50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: user?.avatarImage ?? User.defaultAvatarImg
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
