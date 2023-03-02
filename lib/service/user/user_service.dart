import 'package:frontend/service/security/security_service.dart';
import 'package:frontend/service/services.dart';

import '../../model/being/user/user.dart';

class UserService {
  SecurityService securityService = Services.securityService;

  User? _currentUser;
  Future<User?> get currentUser => () async {
    String? name = await securityService.currentUserName;
    String? lastname = await securityService.currentUserLastname;
    if (name != null && lastname != null) {
      _currentUser ??= User(
        id: await securityService.currentUserId,
        name: name,
        lastname: lastname,
      );
    }
    return _currentUser;
  }();

  User? get currentUserUnsafe => _currentUser;

  Future<User?> findById(String id) async {
    // TODO
    return null;
  }
}
