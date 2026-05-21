import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';

class ApiDio {
  ApiDio._();

  // Cached SharedPreferences instance — avoids an async lookup on every request.
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> _getPrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<String?> _readAuthToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(AppConstants.prefsAuthTokenKey);
  }

  static String? _authorizationHeaderFromToken(String? token) {
    final t = token?.trim();
    if (t == null || t.isEmpty) return null;
    // Some callers may already persist the full header value.
    if (t.toLowerCase().startsWith('bearer ')) {
      final raw = t.substring('bearer '.length).trim();
      if (raw.isEmpty) return null;
      return 'Bearer $raw';
    }
    return 'Bearer $t';
  }

  static Future<Dio> authed() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {'Accept': 'application/json'},
      ),
    );

    // Important: services can be constructed before login completes.
    // Read token fresh for every request so the first request after login
    // also carries Authorization without requiring app reload.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _readAuthToken();
          final authorization = _authorizationHeaderFromToken(token);
          if (authorization != null) {
            options.headers['Authorization'] = authorization;
          } else {
            options.headers.remove('Authorization');
          }
          handler.next(options);
        },
      ),
    );

    return dio;
  }

  static Dio unAuthed() {
    return Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }
}
