import 'dart:developer';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/service/security/security_service.dart';
import 'package:frontend/service/services.dart';
import 'package:frontend/service/watch/watch_service.dart';

void main() {
  group('Watch Service Tests', () {

    SecurityService securityService = Services.securityService;
    WatchService watchService = Services.watchService;
    String contentFilePath = './test/resource/video/world.mp4';
    late File content;

    setUp(() => content = File(contentFilePath));

    test('Content file exists test.', () async {
      expect(await content.absolute.exists(), true);
    });

    test('Watch Service Add Media Test', () async { // Watch Service and Security Service must running!
      await dotenv.load(fileName: '.env.dev');
      File content = File('./test/resource/video/world.mp4');

      await securityService.login(dotenv.get('TEST_USERNAME'), dotenv.get('TEST_PASSWORD'))
        .then((loggedIn) {
          expect(loggedIn, true);
        }).whenComplete(() => watchService.add(
          'What\'s up?',
          'It\'s simple description.',
          content,
          null,
          false
      )).then((uuid) => expect(uuid, isNot(null)));
    });
  });
}
