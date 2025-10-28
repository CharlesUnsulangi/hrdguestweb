import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/application.dart';
import '../models/user.dart';
import '../utils/safe_run.dart';

class ApiService {
  final String baseUrl;
  final http.Client httpClient;

  ApiService({required this.baseUrl, http.Client? client})
    : httpClient = client ?? http.Client();

  Future<User?> fetchUser(String id) async {
    final result = await safeAsync<Map<String, dynamic>?>(() async {
      final resp = await httpClient
          .get(Uri.parse('$baseUrl/users/$id'))
          .timeout(const Duration(seconds: 10));
      if (resp.statusCode != 200) return null;
      return json.decode(resp.body) as Map<String, dynamic>;
    });

    if (result == null) return null;
    return User.fromJson(result);
  }

  /// Submit an application to the backend. Returns true on success.
  Future<bool> submitApplication(Application app) async {
    final result = await safeAsync<bool>(() async {
      final uri = Uri.parse('$baseUrl/applications');
      final resp = await httpClient
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(app.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      return resp.statusCode == 200 || resp.statusCode == 201;
    }, timeout: const Duration(seconds: 15));

    return result ?? false;
  }
}
