import 'dart:async';
import 'dart:convert';

import 'package:bitbucket_code_coverage/src/client/model/commit_coverage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:quiver/check.dart';

abstract class CodeCoverageService {
  Future<CommitCoverage> post(String commitId, CommitCoverage commitCoverage);

  static CodeCoverageService from(
      {required String url, required String token, required String username, required String password}) {
    return _DefaultCodeCoverageService(
        baseUrl: url, token: token, username: username, password: password);
  }
}

class _DefaultCodeCoverageService implements CodeCoverageService {
  final Logger logger = Logger.root;
  
  final String baseUrl;
  final String token;
  final String username;
  final String password;

  _DefaultCodeCoverageService({required String baseUrl, required this.token, required this.username, required this.password})
      // ignore: deprecated_member_use
      : baseUrl = checkNotNull(baseUrl).endsWith('/')
            ? baseUrl.substring(0, baseUrl.length - 1)
            : baseUrl {
    // ignore: unnecessary_null_comparison
    checkArgument(token != null || (password != null));
  }

  @override
  Future<CommitCoverage> post(String commitId, CommitCoverage commitCoverage) {
    logger.info('request body ${json.encode(commitCoverage.toJson())}');
    return http
        .post(Uri.parse('$baseUrl/rest/code-coverage/1.0/commits/$commitId'),
            headers: <String, String>{
              'Authorization': _toAuthorization(token, username, password),
              'Content-Type': 'application/json'
            },
            body: json.encode(commitCoverage.toJson()))
        .then((Response response) =>
            CommitCoverage.fromJson(<String, dynamic>{'files': json.decode(response.body)}));
  }

  String _toAuthorization(String token, String username, String password) {
    if (token.isNotEmpty) {
      return "Bearer $token";
    } else {
      return "Basic ${base64Encode(utf8.encode("$username:$password"))}";
    }
  }
}
