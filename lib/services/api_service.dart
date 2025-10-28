import 'dart:convert';

import 'package:hrdguestweb/models/dto/ms_employee_dto.dart';
import 'package:hrdguestweb/models/dto/paged_response.dart';
import 'package:hrdguestweb/models/dto/tr_hr_pelamar_driver_dto.dart';
import 'package:hrdguestweb/models/dto/tr_hr_pelamar_pengalaman_perusahaan_dto.dart';
import 'package:hrdguestweb/models/dto/tr_hr_pelamar_personal_dto.dart';
import 'package:hrdguestweb/models/dto/tr_hr_pelamar_sosmed_dto.dart';
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

  /// Fetch list of pelamar personal data
  Future<List<TrHrPelamarPersonalDto>?> getPelamarPersonal() async {
    final result = await safeAsync<List<TrHrPelamarPersonalDto>?>(() async {
      final uri = Uri.parse('$baseUrl/api/TrHrPelamarPersonal');
      final resp = await httpClient.get(uri).timeout(
          const Duration(seconds: 10));
      if (resp.statusCode != 200) return null;
      final List<dynamic> j = json.decode(resp.body) as List<dynamic>;
      return j
          .map((e) =>
          TrHrPelamarPersonalDto.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }, timeout: const Duration(seconds: 15));

    return result;
  }

  /// Fetch paged employees from API
  Future<PagedResponse<MsEmployeeDto>?> getEmployees(
      {int page = 1, int pageSize = 10, String sortDir = 'asc'}) async {
    final result = await safeAsync<PagedResponse<MsEmployeeDto>?>(() async {
      final uri = Uri.parse(
          '$baseUrl/api/MsEmployee?pageNumber=$page&pageSize=$pageSize&sortDir=$sortDir');
      final resp = await httpClient.get(uri).timeout(
          const Duration(seconds: 10));
      if (resp.statusCode != 200) return null;
      final Map<String, dynamic> j = json.decode(resp.body) as Map<
          String,
          dynamic>;
      return PagedResponse.fromJson(j, (m) => MsEmployeeDto.fromJson(m));
    }, timeout: const Duration(seconds: 15));

    return result;
  }

  /// Submit an application to the backend. Returns true on success.
  Future<bool> submitApplication(Application app) async {
    final result = await safeAsync<bool>(() async {
      final uri = Uri.parse('$baseUrl/applications');
      final resp = await httpClient.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(app.toJson()),
      ).timeout(const Duration(seconds: 10));

      return resp.statusCode == 200 || resp.statusCode == 201;
    }, timeout: const Duration(seconds: 15));

    return result ?? false;
  }

  /// Fetch list of pelamar pengalaman perusahaan
  Future<List<
      TrHrPelamarPengalamanPerusahaanDto>?> getPelamarPengalamanPerusahaan() async {
    final result = await safeAsync<
        List<TrHrPelamarPengalamanPerusahaanDto>?>(() async {
      final uri = Uri.parse('$baseUrl/api/TrHrPelamarPengalamanPerusahaan');
      final resp = await httpClient.get(uri).timeout(
          const Duration(seconds: 10));
      if (resp.statusCode != 200) return null;
      final List<dynamic> j = json.decode(resp.body) as List<dynamic>;
      return j.map((e) =>
          TrHrPelamarPengalamanPerusahaanDto.fromJson(
          Map<String, dynamic>.from(e as Map))).toList();
    }, timeout: const Duration(seconds: 15));

    return result;
  }

  /// Fetch list of pelamar driver
  Future<List<TrHrPelamarDriverDto>?> getPelamarDriver() async {
    final result = await safeAsync<List<TrHrPelamarDriverDto>?>(() async {
      final uri = Uri.parse('$baseUrl/api/TrHrPelamarDriver');
      final resp = await httpClient.get(uri).timeout(
          const Duration(seconds: 10));
      if (resp.statusCode != 200) return null;
      final List<dynamic> j = json.decode(resp.body) as List<dynamic>;
      return j
          .map((e) =>
          TrHrPelamarDriverDto.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }, timeout: const Duration(seconds: 15));

    return result;
  }

  /// Fetch list of pelamar social media
  Future<List<TrHrPelamarSosmedDto>?> getPelamarSosmed() async {
    final result = await safeAsync<List<TrHrPelamarSosmedDto>?>(() async {
      final uri = Uri.parse('$baseUrl/api/TrHrPelamarSosmed');
      final resp = await httpClient.get(uri).timeout(
          const Duration(seconds: 10));
      if (resp.statusCode != 200) return null;
      final List<dynamic> j = json.decode(resp.body) as List<dynamic>;
      return j
          .map((e) =>
          TrHrPelamarSosmedDto.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }, timeout: const Duration(seconds: 15));

    return result;
  }
}
