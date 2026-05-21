import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<File> compressImage(File file) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filename = file.path.split(Platform.pathSeparator).last;
      final dotIndex = filename.lastIndexOf('.');
      final ext = dotIndex != -1 ? filename.substring(dotIndex).toLowerCase() : '.jpg';
      final nameWithoutExt = dotIndex != -1 ? filename.substring(0, dotIndex) : filename;

      CompressFormat format = CompressFormat.jpeg;
      String targetExt = '.jpg';
      if (ext == '.webp') {
        format = CompressFormat.webp;
        targetExt = '.webp';
      } else if (ext == '.heic') {
        format = CompressFormat.heic;
        targetExt = '.heic';
      } else if (ext == '.png') {
        format = CompressFormat.png;
        targetExt = '.png';
      }

      final targetPath = '${tempDir.path}/${nameWithoutExt}_compressed_${DateTime.now().millisecondsSinceEpoch}$targetExt';
      final originalSize = await file.length();

      final XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 50,
        minWidth: 1280,
        minHeight: 720,
        format: format,
      );

      if (compressedXFile == null) {
        debugPrint('[ImageCompress] Compression returned null for: ${file.path}. Using original.');
        return file;
      }

      final compressedFile = File(compressedXFile.path);
      final compressedSize = await compressedFile.length();

      if (kDebugMode) {
        debugPrint('[ImageCompress] Success: ${file.path}');
        debugPrint('[ImageCompress] Original size: ${(originalSize / 1024).toStringAsFixed(2)} KB');
        debugPrint('[ImageCompress] Compressed size: ${(compressedSize / 1024).toStringAsFixed(2)} KB');
        debugPrint('[ImageCompress] Saved to: $targetPath');
      }

      return compressedFile;
    } catch (e) {
      debugPrint('[ImageCompress] Error compressing ${file.path}: $e. Using original.');
      return file;
    }
  }

  Future<Agent> updateProfile({required String name, File? image}) async {
    final dio = await ApiDio.authed();

    try {
      File? finalImage = image;
      if (finalImage != null) {
        finalImage = await compressImage(finalImage);
      }

      final form = FormData.fromMap({
        'name': name,
        if (finalImage != null)
          'image': await MultipartFile.fromFile(
            finalImage.path,
            filename: finalImage.path.split(Platform.pathSeparator).last,
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
