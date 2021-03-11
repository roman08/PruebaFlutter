import 'dart:async';

import 'package:api_error_parser/api_error_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../app.dart';
import '../../common/models/file_info.dart';
import '../../common/session/session_repository.dart';
import '../api_constants.dart';
import '../network_client.dart';

class FileProvider {
  final NetworkClient _networkClient;
  final SessionRepository _sessionRepository;
  final ApiConstants apiConstants = ApiConstants();

  FileProvider(
    this._sessionRepository,
    this._networkClient,
  );

  Future<ApiResponseEntity<FileInfo>> uploadFile({String path}) async {
    final uid = _sessionRepository.uid;

    final result = await FlutterImageCompress.compressWithFile(
      path,
      quality: 70,
      minWidth: 300,
      minHeight: 400,
    );

    final FormData formData = FormData.fromMap(
        {"file": MultipartFile.fromBytes(result, filename: "image.jpg")});

    try {
      final Response response = await _networkClient.dio.post(
        apiConstants.file.privateFile(id: uid),
        data: formData,
      );
      return ApiResponseEntity<FileInfo>.fromJson(
          response.data as Map<String, dynamic>, FileInfo.fromJson);
    } catch (error) {
      logger.e(error.toString());
      return Future.value(null);
    }
  }

  Future<ApiResponseEntity<FileInfo>> getFile({int id}) async {
    try {
      final Response response = await _networkClient.dio.get(
        apiConstants.file.file(id: id),
      );

      return ApiResponseEntity<FileInfo>.fromJson(
          response.data as Map<String, dynamic>, FileInfo.fromJson);
    } catch (error) {
      logger.e(error.toString());
      return Future.value(null);
    }
  }

  Future<List<int>> getBin({int id}) async {
    try {
      final Response response = await _networkClient.dio.get(
        apiConstants.file.bin(id: id),
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      return response.data;
    } catch (error) {
      logger.e(error.toString());
      return Future.value(null);
    }
  }

  Future<ApiResponseEntity<FileInfo>> uploadProfileImage({String path}) async {
    final result = await FlutterImageCompress.compressWithFile(
      path,
      quality: 70,
      minWidth: 300,
      minHeight: 300,
    );

    final FormData formData = FormData.fromMap(
        {"file": MultipartFile.fromBytes(result, filename: "image.jpg")});

    try {
      final Response response = await _networkClient.dio.post(
        apiConstants.file.profileImage,
        data: formData,
      );
      return ApiResponseEntity<FileInfo>.fromJson(
          response.data as Map<String, dynamic>, FileInfo.fromJson);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<FileInfo>.fromJson(
          error.response.data as Map<String, dynamic>, null);
    }
  }
}
