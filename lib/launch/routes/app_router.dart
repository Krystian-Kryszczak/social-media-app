import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/service/services.dart';
import 'package:frontend/ui/overlay/main_overlay.dart';
import 'package:frontend/ui/screens/create/finalize/watch/watch_finalizer_screen.dart';
import 'package:frontend/ui/screens/rules/rules_screen.dart';
import 'package:frontend/ui/screens/security/activate_account_screen.dart';
import 'package:frontend/ui/screens/settings/language/language_settings_screen.dart';
import 'package:frontend/ui/screens/settings/theme/theme_settings_screen.dart';
import 'package:frontend/ui/sections/look/look_section.dart';

import '../../io/camera/camera.dart';
import '../../model/section/section_data.dart';
import '../../ui/screens/create/finalize/look/look_finalizer_screen.dart';
import '../../ui/screens/create/select/select_screen.dart';
import '../../ui/screens/security/forgot_password_screen.dart';
import '../../ui/screens/security/login_screen.dart';
import '../../ui/screens/security/register_screen.dart';
import '../../ui/screens/security/switch_user.dart';
import '../../ui/screens/settings/settings_screen.dart';
import '../../ui/screens/user/user_profile_screen.dart';
import '../../ui/sections/watch/watch_player.dart';
import '../../ui/sections/watch/watch_section.dart';

class AppRouter {
  static Future<String> get initialRoute async => dotenv.get('TESTING_INITIAL_ROUTE', fallback: await Services.securityService.isLogged() ? homeRoute : loginRoute);

  static List<SectionData> get sections => [
    // const SectionData(Scaffold(),     Icons.home_outlined,           homeRoute),
    const SectionData(WatchSection(),    Icons.ondemand_video_outlined, watchRoute),
    const SectionData(LookSection(),     Icons.image_outlined,          lookRoute),
    //ScreenData(MessengerScreen(), FontAwesomeIcons.algolia, snapRoute),
    //ScreenData(MessengerScreen(), Icons.forum_outlined, messengerRoute),
  ];

  static Map<String, Widget Function(BuildContext)> get routers => () {
    return {
      // » Home « //
      homeRoute: (context) => const MainOverlay(initialRoute: '/'),
      
      // » Search « //
      // searchRoute: (context) => const SearchScreen(),
      // searchFriendsRoute: (context) => const FriendsList(),

      // » Being « //
      profileRoute: (context) => const UserProfileScreen(),
      // groupsRoute: (context) => const GroupsList(),
      // pagesRoute: (context) => const PagesList(),

      // » Events « //
      // eventsRoute: (context) => const EventsList(),

      // » Notifications « //
      // notificationsRoute: (context) => const NotificationsScreen(),

      // // » Settings « //
      settingsRoute: (context) => const SettingsScreen(),
      languageSettingsRoute: (context) => const LanguageSettingsScreen(),
      themeSettingsRoute: (context) => const ThemeSettingsScreen(),

      // » Auth « //
      loginRoute: (context) => const LoginScreen(),
      registerRoute: (context) => const RegisterScreen(),
      forgotPasswordRoute: (context) => const ForgotPasswordScreen(),
      switchUserRoute: (context) => const SwitchUser(),
      activateAccountRoute: (context) => const ActivateAccountScreen(),

      // » Exhibit « //
      watchRoute: (context) => const MainOverlay(initialRoute: watch),
      watchPlayerRoute: (context) => const WatchPlayer(),
      // reelsRoute: (context) => const Reels(),
      // storiesRoute: (context) => const StoriesSwiper(),
      // imagesRoute: (context) => Container(),
      // snapRoute: (context) => Container(),
      // forumsRoute: (context) => Container(),
      // tweeterRoute: (context) => Container(),
      // storeRoute: (context) => Container(),
      // filmsRoute: (context) => Container(),
      // musicRoute: (context) => Container(),

      // » Drive « //
      // driveRoute: (context) => Container(),

      // » Messenger « //
      // messengerRoute: (context) => const MessengerScreen(),

      // » Create « //
      createRoute: (context) => const CreateScreen(),
      createWatchRoute: (context) => const CreateScreen(initialRoute: watch),
      createLookRoute: (context) => const CreateScreen(initialRoute: look),
      // createRelationRoute: (context) => const CreateScreen(initialRoute: relation),
      // createReelRoute: (context) => const CreateScreen(initialRoute: reel),
      // createSnapRoute: (context) => const CreateScreen(initialRoute: snap),

      // » Edit Exhibit « // TODO
      editWatchRoute: (context) => const CreateScreen(initialRoute: watch),
      editLookRoute: (context) => const CreateScreen(initialRoute: look), // TODO
      // editRelationRoute: (context) => const CreateScreen(initialRoute: relation),
      // editReelRoute: (context) => const CreateScreen(initialRoute: reel),
      // editSnapRoute: (context) => const CreateScreen(initialRoute: snap),

      // » Finalize Exhibit « // TODO
      finalizeWatchRoute: (context) => const WatchFinalizerScreen(),
      finalizeLookRoute: (context) => const LookFinalizerScreen(), // TODO
      // finalizeRelationRoute: (context) => const CreateScreen(initialRoute: relation),
      // finalizeReelRoute: (context) => const CreateScreen(initialRoute: reel),
      // finalizeSnapRoute: (context) => const CreateScreen(initialRoute: snap),

      // » Camera « //
      cameraRoute: (context) => CameraData.getCamera(),

      // » Rules « //
      rulesRoute: (context) => const RulesScreen(),
    };
  } ();
  // » Home « //
  static const String homeRoute = '/';

  // » Search « //
  static const String searchRoute = '/search/';
  static const String searchFriendsRoute = '/search/friends/';

  // » Being « //
  static const String profileRoute = '/profile/';
  static const String groupsRoute = '/groups/';
  static const String pagesRoute = '/pages/';

  // » Events « //
  static const String eventsRoute = '/events/';

  // » Notifications « //
  static const String notificationsRoute = '/notifications/';

  // » Settings « //
  static const String settingsRoute = '/settings/';
  static const String languageSettingsRoute = '/settings/language/';
  static const String themeSettingsRoute = '/settings/theme/';

  // » Auth « //
  static const String loginRoute = '/login/';
  static const String registerRoute = '/register/';
  static const String forgotPasswordRoute = '/forgot-password/';
  static const String switchUserRoute = '/switch-user/';
  static const String activateAccountRoute = '/activate-account/';

  // » Exhibit « //
  static const String watchRoute = '/watch/';
  static const String watchPlayerRoute = '/watch-player/';
  static const String reelsRoute = '/reels/';
  static const String storiesRoute = '/stories/';
  static const String lookRoute = '/look/';
  static const String snapRoute = '/snap/';

  // » Messenger « //
  static const String messengerRoute = 'messenger';

  // » Create « //
  static const String createRoute = '/create/';
  static const String createLookRoute = '/create/look/';
  static const String createWatchRoute = '/create/watch/';
  static const String createRelationRoute = '/create/relation/';
  static const String createReelRoute = '/create/reel/';
  static const String createSnapRoute = '/create/snap/';

  // » Edit Exhibit « //
  static const String editWatchRoute = '/edit/watch/';
  static const String editLookRoute = '/edit/look/';
  static const String editRelationRoute = '/edit/relation/';
  static const String editReelRoute = '/edit/reel/';
  static const String editSnapRoute = '/edit/snap/';

  // » Finalize Exhibit « //
  static const String finalizeWatchRoute = '/finalize/watch/';
  static const String finalizeLookRoute = '/finalize/look/';
  static const String finalizeRelationRoute = '/finalize/relation/';
  static const String finalizeReelRoute = '/finalize/reel/';
  static const String finalizeSnapRoute = '/finalize/snap/';

  // » Device « //
  static const String cameraRoute = '/camera/';

  // » Rules « //
  static const String rulesRoute = '/rules/';
  // -------------------------------------------------- //
  // Exhibits names
  static const String watch = 'watch';
  static const String look = 'look';
  static const String relation = 'relation';
  static const String reel = 'reel';
  static const String snap = 'snap';
}
