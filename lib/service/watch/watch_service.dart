import 'dart:convert';
import 'dart:io';

import 'package:frontend/io/network/app_http.dart';
import 'package:frontend/io/network/endpoints.dart';
import 'package:http/http.dart';

import '../../model/exhibit/watch/watch.dart';

class WatchService {
  Future<List<Watch>> propose() async {
    List<Watch> watchList = [];
    Response response = await (AppHttp.get(Endpoints.watch));
    if (response.statusCode.toString().startsWith('2')) {
      Iterable<Watch> decoded = (jsonDecode(response.body) as List<dynamic>)
        .map((item) => item.cast<String, dynamic>())
          .map((item) => Watch.fromMap(item));
      watchList.addAll(decoded);
    }
    return watchList;
  }

  Future<Watch?> findById(String id) async {
    Response resp = await AppHttp.get(Endpoints.watch + id);
    if (!resp.statusCode.toString().startsWith("2")) return null;
    return Watch.fromMap(jsonDecode(resp.body) as Map<String, Object>);
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

    return AppHttp.multipartRequest(Endpoints.watch, fields: fields, files: files)
      .then((request) => request.send())
      .then(
        (streamResp) => streamResp.statusCode.toString().startsWith('2')
          ? streamResp.stream.bytesToString()
          : null
      );
  }
}
