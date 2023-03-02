import 'dart:io';

import 'package:frontend/service/services.dart';

import '../language/language.dart';
import '../settings/settings.dart';
import './routes/config/configure_noweb.dart'
if (dart.library.html) './routes/config/configure_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../io/camera/camera.dart';

class Launcher {
  static Future<void> configurePlatform() async {
    // ------------------------- //
        await _configureBasic();
    // ------------------------- //
    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) { // Android & IOS
        await _configureMobile();
      } else { // Desktop
        await _configureDesktop();
      }
    } else { // Web
      await _configureWeb();
    }
  }
  static Future<void> _configureBasic() async {
    await dotenv.load(fileName: '.env${!kReleaseMode?'.dev':'.prod'}');
    await Settings.loadSettings();
    await Services.securityService.setUp();
    await Language.setUp();
    //await ExhibitData.loadSaved();
    configureUrlStrategy();
  }
  static Future<void> _configureMobile() async {
    await CameraData.loadAvailableCameras();
  }
  static Future<void> _configureDesktop() async {
    //
  }
  static Future<void> _configureWeb() async {
    //
  }
}
