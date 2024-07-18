import 'package:livetex_flutter/data/models/file_uploaded_response.dart';
import 'package:livetex_flutter/core/network_manager.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class ApiManager {
  final Dio dio;
  String? _authToken;

  ApiManager(this.dio);

  void setAuthToken(String authToken) {
    _authToken = authToken;
  }

  Future<FileUploadedResponse> uploadFile(File file) async {
    if (_authToken == null) {
      throw StateError("uploadFile called with null auth token");
    }

    final fileName = Uri.encodeComponent(path.basename(file.path));
    final formData = FormData.fromMap({
      'fileUpload': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final response = await dio.post(
      NetworkManager.instance.uploadEndpoint,
      data: formData,
      options: Options(
        headers: {'Authorization': 'Bearer $_authToken'},
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.data.toString());
      return FileUploadedResponse.fromMap(data);
    } else {
      throw Exception("Response is ${response.statusCode}");
    }
  }
}
