import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  static String? __protocol, __securityHost, __watchHost, __lookHost, __mediaHost, __informationHost;
  static String get _protocol => (__protocol ??= dotenv.get('CONNECTION_PROTOCOL', fallback: 'HTTPS')).toLowerCase();
  static String get _securitySocket => ('$_protocol://${__securityHost ??= dotenv.get('SECURITY_HOST')}').toLowerCase();
  static String get _watchSocket => ('$_protocol://${__watchHost ??= dotenv.get('WATCH_HOST')}').toLowerCase();
  static String get _lookSocket => ('$_protocol://${__lookHost ??= dotenv.get('LOOK_HOST')}').toLowerCase();
  static String get _mediaSocket => ('$_protocol://${__mediaHost ??= dotenv.get('MEDIA_HOST')}').toLowerCase();
  static String get _informationSocket => ('$_protocol://${__informationHost ??= dotenv.get('INFORMATION_HOST')}').toLowerCase();
  // -------------------------------------------------- //
  static String login = '$_securitySocket/login/';
  static String register = '$_securitySocket/register/';
  static String activateAccount = '$_securitySocket/activate-account/';
  static String changePassword = '$_securitySocket/change-password/';
  static String resetPassword = '$_securitySocket/reset-password/';
  static String resetCode = '$_securitySocket/reset-code/';
  // -------------------------------------------------- //
  // static String news = '${api}news/'; // home
  // static String posts = '${api}posts/';
  // static String reels = '${api}reels/';
  // static String snaps = '${api}snaps/';
  // static String songs = '${api}songs/';
  // static String stories = '${api}stories/';
  static String watch = '$_watchSocket/watch/';
  static String look = '$_lookSocket/look/';
  // static String explore = '${images}explore/';
  // -------------------------------------------------- //
  static String video = '$_mediaSocket/video/';
  static String images = '$_mediaSocket/images/';
  static String audio = '$_mediaSocket/audio/';
  // -------------------------------------------------- //
  // static String users = '${api}users/';
  // static String groups = '${api}groups/';
  // static String pages = '${api}pages/';
  // -------------------------------------------------- //
  static String rules = '$_informationSocket/rules/';
  // -------------------------------------------------- //
}
