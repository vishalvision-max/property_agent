import 'dart:io';

import 'package:dio/dio.dart';

import '../models/agent.dart';
import 'api_dio.dart';

class StaffAccountService {
  StaffAccountService();

  Future<Agent> getProfile() async {
    final dio = await ApiDio.authed();
    try {
      final res = await dio.get<Map<String, dynamic>>(
        '/staff/profile',
        options: Options(headers: const {'accept': 'application/json'}),
      );
      final body = res.data ?? const <String, dynamic>{};
      final data = (body['data'] is Map<String, dynamic>)
          ? (body['data'] as Map<String, dynamic>)
          : body;
      return Agent.fromJson(Map<String, dynamic>.from(data));
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map<String, dynamic> ? data['message'] : null)
          ?.toString();
      throw Exception((msg == null || msg.isEmpty) ? 'Profile fetch failed' : msg);
    }
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    final dio = await ApiDio.authed();

    try {
      await dio.post<Map<String, dynamic>>(
        '/staff/password/update',
        data: FormData.fromMap({
          'current_password': currentPassword,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
        options: Options(
          headers: const {'accept': 'application/json'},
        ),
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map<String, dynamic> ? data['message'] : null)
          ?.toString();
      throw Exception((msg == null || msg.isEmpty) ? 'Password update failed' : msg);
    }
  }

  Future<Agent> updateProfile({required String name, File? image}) async {
    final dio = await ApiDio.authed();

    try {
      final form = FormData.fromMap({
        'name': name,
        if (image != null)
          'image': await MultipartFile.fromFile(
            image.path,
            filename: image.path.split(Platform.pathSeparator).last,
          ),
      });

      final res = await dio.post<Map<String, dynamic>>(
        '/staff/edit/profile',
        data: form,
        options: Options(
          headers: const {'accept': 'application/json'},
        ),
      );
      final body = res.data ?? const <String, dynamic>{};
      final data = (body['data'] is Map<String, dynamic>)
          ? (body['data'] as Map<String, dynamic>)
          : body;
      return Agent.fromJson(Map<String, dynamic>.from(data));
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map<String, dynamic> ? data['message'] : null)
          ?.toString();
      throw Exception(
        (msg == null || msg.isEmpty) ? 'Profile update failed' : msg,
      );
    }
  }
}
