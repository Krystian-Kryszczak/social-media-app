import 'dart:convert';

import 'package:frontend/io/network/endpoints.dart';
import 'package:frontend/model/rules/rules.dart';
import 'package:http/http.dart';

class RulesService {
  Future<Rules> fetchRules() => get(Uri.parse(Endpoints.rules))
      .then((response) => jsonDecode(response.body))
        .then((data) => Rules.fromJson(data));
}
