import 'package:dio/dio.dart';

import '../models/agent.dart';
import 'api_dio.dart';
import 'auth_service.dart';

class StaffAuthService implements AuthService {
  StaffAuthService({Dio? dio}) : _dio = dio ?? ApiDio.unAuthed();

  final Dio _dio;

  @override
  Future<Agent> login({required String email, required String password}) async {
    Response<Map<String, dynamic>> res;
    try {
      final identifier = email.trim();
      res = await _dio.post<Map<String, dynamic>>(
        '/staff/login',
        data: {
          // Backend environments differ: some expect email, others staff id/username.
          // Send a superset to avoid missing params.
          'email': identifier,
          'id': identifier,
          'staff_id': identifier,
          'username': identifier,
          'password': password,
        },
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map<String, dynamic> ? data['message'] : null)?.toString();
      throw Exception((msg == null || msg.isEmpty) ? 'Login failed' : msg);
    }

    final body = res.data ?? const <String, dynamic>{};
    print('[StaffAuthService] Login response body: $body');

    String token = '';
    Map<String, dynamic> data;
    if (body['data'] is String) {
      token = body['data'].toString();
      data = body;
    } else {
      data = (body['data'] is Map<String, dynamic>) ? (body['data'] as Map<String, dynamic>) : body;
      token = (data['token'] ??
              data['access_token'] ??
              data['token_type'] ??
              body['token'] ??
              body['access_token'] ??
              '')
          .toString();
    }

    if (token.isEmpty) {
      throw Exception('Login succeeded but token missing');
    }

    final user = (data['user'] is Map<String, dynamic>) ? (data['user'] as Map<String, dynamic>) : const <String, dynamic>{};

    final name = (data['name'] ?? user['name'] ?? 'Agent').toString();
    final id = (data['id'] ?? user['id'] ?? 'staff').toString();
    final normalizedEmail = (data['email'] ?? user['email'] ?? email).toString();
    final imageRaw = (data['image'] ?? user['image'] ?? '').toString().trim();

    return Agent(
      id: id,
      name: name,
      email: normalizedEmail,
      token: token,
      image: imageRaw.isEmpty ? null : imageRaw,
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      final identifier = email.trim();
      await _dio.post<Map<String, dynamic>>(
        '/staff/forget/password',
        data: {
          'email': identifier,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'email': identifier,
          },
        ),
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map<String, dynamic> ? data['message'] : null)?.toString();
      throw Exception((msg == null || msg.isEmpty) ? 'Forgot password request failed' : msg);
    }
  }
}
