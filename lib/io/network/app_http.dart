import 'dart:convert';
import 'dart:developer';
import 'package:frontend/service/security/security_service.dart';
import 'package:frontend/service/services.dart';
import 'package:http/http.dart' as http;

class AppHttp {
  static Future<Map<String, String>> authHeader() async {
    SecurityService securityService = Services.securityService;
    String? jwtAccessToken = await securityService.currentUserJwtAccessToken;
    String? tokenType = await securityService.currentUserTokenType;
    if (jwtAccessToken!=null && tokenType!=null) {
      return {'Authorization': '$tokenType $jwtAccessToken'};
    } else {
      if (await securityService.refresh()) {
        return {'Authorization': '${tokenType!} ${jwtAccessToken!}'};
      }
      log('Authorization failed!');
      return {};
    }
  }

  static Future<Map<String, String>> _headersBase({Map<String,String> headers = const {}}) async {
    Map<String, String> headers = await authHeader();
    headers.addAll({
      "Access-Control-Allow-Origin": "*"
    });
    headers.addAll(headers);
    return headers;
  }

  static final Encoding? encoding = Encoding.getByName('utf-8');

  static Future<http.Response> get(String url, {Map<String,String> headers = const {}}) async =>
      http.get(Uri.parse(url), headers: await _headersBase(headers: headers));

  static Future<http.Response> post(String url, {Map<String,String> headers = const {}, Object? body, Encoding? encoding}) async =>
      http.post(Uri.parse(url), headers: await _headersBase(headers: headers), body: body, encoding: encoding ?? encoding);

  static Future<http.Response> delete(String url, {Map<String,String> headers = const {}, Object? body, Encoding? encoding}) async =>
      http.delete(Uri.parse(url), headers: await _headersBase(headers: headers), body: body, encoding: encoding ?? encoding);

  static Future<http.Response> head(String url, {Map<String,String> headers = const {}}) async =>
      http.head(Uri.parse(url), headers: await _headersBase(headers: headers));

  static Future<http.Response> patch(String url, {Map<String,String> headers = const {}, Object? body, Encoding? encoding}) async =>
      http.patch(Uri.parse(url), headers: await _headersBase(headers: headers), body: body, encoding: encoding ?? encoding);

  static Future<http.Response> put(String url, {Map<String,String> headers = const {}, Object? body, Encoding? encoding}) async =>
      http.put(Uri.parse(url), headers: await _headersBase(headers: headers), body: body, encoding: encoding ?? encoding);

  static Future<http.MultipartRequest> multipartRequest(String url, {String method = 'POST', List<http.MultipartFile> files = const [], Map<String, String> fields = const {}, Map<String, String> headers = const {}}) async {
    http.MultipartRequest request = http.MultipartRequest(method, Uri.parse(url));
    Map<String, String> allHeaders = await _headersBase(headers: headers);
    allHeaders.forEach((key, value) => request.headers[key] = value);
    request.fields.addAll(fields);
    request.files.addAll(files);
    return request;
  }

  static void logHttpConnection(http.Response response) {
    log('Url » ${response.request?.url.toString()} Method » ${response.request?.method} Status code » ${response.statusCode.toString()}');
    log('Body » ${response.body}');
  }
}
