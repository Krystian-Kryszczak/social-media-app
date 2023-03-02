import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../io/network/endpoints.dart';
import '../../io/network/app_http.dart';
import '../../io/storage/local_storage.dart';

class SecurityService {
  static const String _idKey = 'id',
      _emailKey = 'email',
      _nameKey = 'name',
      _lastnameKey = 'lastname',
      _passwordKey = 'password',
      _jwtAccessTokenKey = 'jwtAccessToken',
      _tokenTypeKey = 'tokenType',
      _expiresDateTimeKey = 'expiresDateTime';
  String? _currentUserId,
      _currentUserEmail,
      _currentUserName,
      _currentUserLastname,
      _currentUserPassword,
      _jwtAccessToken,
      _tokenType;
  DateTime? _expiresDateTime;

  Future<String?> get currentUserId => (() async => _currentUserId ?? await LocalStorage.readString(key: _idKey))();
  Future<String?> get currentUserEmail => (() async => _currentUserEmail ?? await LocalStorage.readString(key: _emailKey))();
  Future<String?> get currentUserName => (() async => _currentUserName ?? await LocalStorage.readString(key: _nameKey))();
  Future<String?> get currentUserLastname => (() async => _currentUserLastname ?? await LocalStorage.readString(key: _lastnameKey))();
  Future<String?> get currentUserPassword => (() async => _currentUserPassword ?? await LocalStorage.readString(key: _passwordKey))();
  Future<String?> get currentUserJwtAccessToken => (() async => _jwtAccessToken ?? await LocalStorage.readString(key: _jwtAccessTokenKey))();
  Future<String?> get currentUserTokenType => (() async => _tokenType ?? await LocalStorage.readString(key: _tokenTypeKey))();
  Future<DateTime?> get currentUserTokenExpiresDateTime => (() async => _expiresDateTime ?? DateTime.tryParse(await LocalStorage.readString(key: _expiresDateTimeKey) ?? ''))();

  Future<bool> setEmailAndPassword({required String email, required String password}) async =>
      await Future(() { _currentUserEmail = email; _currentUserPassword = password; })
        .whenComplete(() => LocalStorage.writeString(key: _emailKey, value: email))
            .whenComplete(() => LocalStorage.writeString(key: _passwordKey, value: password))
              .then((value) => true).onError((error, stackTrace) => false);

  Future<void> setUp() async => await LocalStorage.readString(key: _idKey)
      .then((value) => _currentUserId = value)
    .whenComplete(() => LocalStorage.readString(key: _emailKey))
      .then((value) => _currentUserEmail = value)
    .whenComplete(() => LocalStorage.readString(key: _nameKey))
      .then((value) => _currentUserName = value)
    .whenComplete(() => LocalStorage.readString(key: _lastnameKey))
      .then((value) => _currentUserLastname = value)
    .whenComplete(() => LocalStorage.readString(key: _passwordKey))
      .then((value) => _currentUserPassword = value)
    .whenComplete(() => LocalStorage.readString(key: _jwtAccessTokenKey))
      .then((value) => _jwtAccessToken = value)
    .whenComplete(() => LocalStorage.readString(key: _tokenTypeKey))
      .then((value) => _tokenType = value)
    .whenComplete(() => LocalStorage.readString(key: _expiresDateTimeKey))
      .then((value) => _expiresDateTime = DateTime.tryParse(value ?? ''));

  Future<bool> login(String email, String password) async {
    Uri uri = Uri.parse(Endpoints.login);
    http.Response response = await http.post(uri, body: {'username': email, 'password': password});
    // -------------------------------------------------- //
    if (response.statusCode.toString().startsWith("2")) {
      Map<String, dynamic> decoded = jsonDecode(response.body);
      
      String email = decoded['username'] as String;
      _currentUserEmail = decoded['username'] as String;
      LocalStorage.writeString(key: _emailKey, value: email);

      _currentUserId = decoded['id'] as String?;
      if (_currentUserId != null) LocalStorage.writeString(key: _idKey, value: _currentUserId!);
      
      _currentUserPassword = password;
      LocalStorage.writeString(key: _passwordKey, value: password);

      String jwtAccessToken = decoded['access_token'] as String;
      _jwtAccessToken = jwtAccessToken;
      LocalStorage.writeString(key: _jwtAccessTokenKey, value: jwtAccessToken);

      String tokenType = decoded['token_type'] as String;
      _tokenType = tokenType;
      LocalStorage.writeString(key: _tokenTypeKey, value: tokenType);

      DateTime expiresDateTime = DateTime.now().add(Duration(seconds: decoded['expires_in'] as int));
      _expiresDateTime = expiresDateTime;
      LocalStorage.writeString(key: _expiresDateTimeKey, value: expiresDateTime.toString());

      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _currentUserId = null;
    LocalStorage.remove(key: _idKey);

    _currentUserEmail = null;
    LocalStorage.remove(key: _emailKey);

    _currentUserName = null;
    LocalStorage.remove(key: _nameKey);

    _currentUserLastname = null;
    LocalStorage.remove(key: _lastnameKey);

    _currentUserPassword = null;
    LocalStorage.remove(key: _passwordKey);

    _jwtAccessToken = null;
    LocalStorage.remove(key: _jwtAccessTokenKey);

    _tokenType = null;
    LocalStorage.remove(key: _tokenTypeKey);

    _expiresDateTime = null;
    LocalStorage.remove(key: _expiresDateTimeKey);
  }

  Future<bool> isLogged() async {
    if (await currentUserTokenExpiresDateTime.then((dateTime) => dateTime?.isBefore(DateTime.now()) != true)) { // the token has expired
      logout();
      return false;
    }
    return await currentUserJwtAccessToken != null;
  }

  Future<bool> refresh() async {
    String? email = await currentUserEmail;
    if (email == null) return false;
    String? password = await currentUserPassword;
    if (password == null) return false;
    return await login(email, password);
  }

  Future<bool> register({ required String email, required String firstname, required String lastname, required String password }) async =>
    post(Uri.parse(Endpoints.register), body: {'email': email, 'name': firstname, 'lastname': lastname, 'password': password}, headers: {'Access-Control-Allow-Origin': '*'})
      .then((resp) => resp.statusCode.toString().startsWith("2"));

  Future<bool> activateAccount({required String email, required String code}) async =>
    post(Uri.parse(Endpoints.activateAccount), body: {'email': email, 'code': code})
      .then((resp) => resp.statusCode.toString().startsWith("2"));

  /// Generates reset password code and sending it to user address email.
  Future<bool> changePassword({required String oldPassword}) async =>
      AppHttp.post(Endpoints.resetPassword, body: {'oldPassword': oldPassword}).then((resp) => resp.statusCode.toString().startsWith('2'));
  
  Future<bool> resetPassword({required String resetCode, required String newPassword}) async =>
    AppHttp.post(Endpoints.resetPassword, body: {'code': resetCode, 'password': newPassword}).then((resp) => resp.statusCode.toString().startsWith('2'));

  // --------------------[ Validation ]-------------------- //
  // r'^'
  //   '(?=.*[A-Z])'       // should contain at least one upper case
  //   '(?=.*[a-z])'       // should contain at least one lower case
  //   '(?=.*?[0-9])'      // should contain at least one digit
  //   '(?=.*?[!@#&*~])'   // should contain at least one Special character
  //   '.{8,20}'           // Must be at least 8-20 characters in length
  // '$'
  static final RegExp _passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#&*~]).{8,20}$');
  static bool validateName(String? name) => (name!=null && name.isNotEmpty && !name.contains(' ')); // returns true when is correct
  static bool validateSurname(String? surname) => (surname!=null && surname.isNotEmpty && !surname.contains(' ')); // returns true when is correct
  static bool validateEmail(String? email) => (email!=null && EmailValidator.validate(email)); // returns true when is correct
  static bool validatePassword(String? password) => (password!=null && password.isNotEmpty && !password.contains(' ') && _passwordRegex.hasMatch(password)); // returns true when is correct
}
