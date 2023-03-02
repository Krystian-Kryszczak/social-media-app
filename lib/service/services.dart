import 'package:frontend/service/look/look_service.dart';
import 'package:frontend/service/media/media_service.dart';
import 'package:frontend/service/notifications/notifications_service.dart';
import 'package:frontend/service/rules/rules_service.dart';
import 'package:frontend/service/security/security_service.dart';
import 'package:frontend/service/user/user_service.dart';
import 'package:frontend/service/watch/watch_service.dart';

class Services {
  static UserService userService = UserService();
  static SecurityService securityService = SecurityService();
  static LookService lookService = LookService();
  static WatchService watchService = WatchService();
  static MediaService mediaService = MediaService();
  static NotificationsService notificationsService = NotificationsService();
  static RulesService rulesService = RulesService();
}
