import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';

import '../../io/network/app_http.dart';
import '../../io/network/endpoints.dart';
import '../../model/exhibit/look/look.dart';

class LookService {
  Future<List<Look>> propose() async {
    List<Look> lookList = [];
    Response response = await AppHttp.get(Endpoints.look);
    if (response.statusCode.toString().startsWith('2')) {
      log(response.body);
      Iterable<Look> decoded = (jsonDecode(response.body) as List<dynamic>)
          .map((item) => item.cast<String, dynamic>())
          .map((item) => Look.fromMap(item));
      lookList.addAll(decoded);
    }
    return lookList;
  }

  Future<Look?> findById(String id) async {
    Response resp = await AppHttp.get(Endpoints.look + id);
    if (!resp.statusCode.toString().startsWith("2")) return null;
    return Look.fromMap(jsonDecode(resp.body) as Map<String, Object>);
  }

  Future<String?> add(String name, String description, File content, File? miniature, bool private) async {
    Map<String, String> fields = {
      'title': name,
      'description': description,
      'private': private.toString()
    };

    List<MultipartFile> files = [
      await MultipartFile.fromPath('content', content.absolute.path),
      if (miniature != null) await MultipartFile.fromPath('miniature', content.absolute.path),
    ];

    return AppHttp.multipartRequest(Endpoints.look, fields: fields, files: files)
        .then((request) => request.send())
        .then(
            (streamResp) => streamResp.statusCode.toString().startsWith('2')
            ? streamResp.stream.bytesToString()
            : null
    );
  }
}
