import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService {
  final Dio _dio;
  ApiService(this._dio);
  Future<Map<String, dynamic>> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.get(endPoint, queryParameters: queryParameters);
    return response.data;
  }

  Future<Response> post({
    required String endPoint,
    Object? data,
    BuildContext? context,
    required Map<String, String> headers,
  }) async {
    var response = await _dio.post(
      endPoint,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    return response;
  }

  Future<Map<String, dynamic>> put({
    required String endPoint,
    required Map<String, dynamic> data,
    required BuildContext context,
  }) async {
    var response = await _dio.put(endPoint, data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> delete({
    required String endPoint,
    Map<String, dynamic>? data,
    required BuildContext context,
  }) async {
    var response = await _dio.delete(endPoint, data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> patch({
    required String endPoint,
    required Map<String, dynamic> data,
    required BuildContext context,
  }) async {
    var response = await _dio.patch(endPoint, data: data, options: Options());
    return response.data;
  }

  Future<Map<String, dynamic>> uploadFormData({
    required String endPoint,
    required FormData formData,
  }) async {
    final response = await _dio.post(
      endPoint,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> uploadFile({
    required String endPoint,
    required Map<String, dynamic> data,
    required Map<String, dynamic> files,
  }) async {
    var formData = FormData.fromMap(data);

    for (var entry in files.entries) {
      if (entry.value is List<String>) {
        for (var path in entry.value) {
          if (path.isNotEmpty) {
            formData.files.add(
              MapEntry(entry.key, await MultipartFile.fromFile(path)),
            );
          }
        }
      } else if (entry.value is String) {
        if (entry.value.isNotEmpty) {
          formData.files.add(
            MapEntry(entry.key, await MultipartFile.fromFile(entry.value)),
          );
        }
      }
    }

    var response = await _dio.post(endPoint, data: formData);
    return response.data;
  }

  Future<Map<String, dynamic>> downloadFile({
    required String endPoint,
    required String savePath,
  }) async {
    var response = await _dio.download(endPoint, savePath);
    return response.data;
  }

  Future<Map<String, dynamic>> downloadFileWithProgress({
    required String endPoint,
    required String savePath,
  }) async {
    var response = await _dio.download(endPoint, savePath);
    return response.data;
  }
}
