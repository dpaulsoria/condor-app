import 'dart:async';
import 'dart:convert';

import "package:dio/dio.dart";
import 'package:material_kit_flutter/constants/config.dart';

class DioClient {
  Dio init() {
    Dio _dio = new Dio();
    _dio.interceptors.add(new ApiInterceptors());
    _dio.options.baseUrl = apiUrl;
    _dio.options.connectTimeout = 15 * 1000;
    return _dio;
  }

  /// Obtener una lista de json en GET
  Future<List<dynamic>> getJsonListRequest(String method,
      {String? url, String? tokenValue}) async {
    try {
      Dio client = this.init();
      client.options.baseUrl = url ?? apiUrl;
      final response = await client.get(method,
          options: Options(headers: {"Authorization": "Bearer $tokenValue"}));
      return (response.data as List).map((x) => x).toList();
    } on DioError catch (ex) {
      redirectErrors(ex);
      print("getJsonListRequest " + ex.message);
    }
    return [];
  }

  /// Obtener una lista de json en POST
  Future<List<dynamic>> postJsonListRequest(String method, dynamic dataValue,
      {String? url, String? tokenValue}) async {
    try {
      Dio client = this.init();
      client.options.baseUrl = url ?? apiUrl;
      final response = await client.post(method,
          data: dataValue,
          options: Options(
            headers: {"Authorization": "Bearer $tokenValue"},
          ));
      return (response.data as List).map((x) => x).toList();
    } on DioError catch (ex) {
      redirectErrors(ex);
      print("postJsonObjectRequest " + ex.message);
    }
    return [];
  }

  /// Obtener un json en POST
  Future<Map<String, dynamic>> postJsonRequest(String method, dynamic dataValue,
      {String? url, String? tokenValue}) async {
    try {
      Dio client = this.init();
      client.options.baseUrl = url ?? apiUrl;
      final response = await client.post(method,
          data: dataValue,
          options: Options(
            headers: {"Authorization": "Bearer $tokenValue"},
          ));
      if (response.data != null) return json.decode(response.toString());
    } on DioError catch (ex) {
      redirectErrors(ex);
      print("postJsonRequest ${ex.message} ${url ?? apiUrl}");
    }
    return Map();
  }

  /// Obtener un json en DELETE
  Future<Map<String, dynamic>> deleteJsonRequest(
      String method, dynamic dataValue,
      {String? url, String? tokenValue}) async {
    try {
      Dio client = this.init();
      client.options.baseUrl = url ?? apiUrl;
      final response = await client.delete(method,
          data: dataValue,
          options: Options(
            headers: {"Authorization": "Bearer $tokenValue"},
          ));
      if (response.data != null) return json.decode(response.toString());
    } on DioError catch (ex) {
      redirectErrors(ex);
      print("postJsonRequest " + ex.message);
    }
    return Map();
  }

  /// Obtener un json en GET
  Future<Map<String, dynamic>> getJsonRequest(String method,
      {String? url, String? tokenValue}) async {
    try {
      Dio client = this.init();
      client.options.baseUrl = url ?? apiUrl;
      final response = await client.get(method,
          options: Options(headers: {"Authorization": "Bearer $tokenValue"}));
      if (response.data != null)
        return json.decode(response.toString());
    } on DioError catch (ex) {
      redirectErrors(ex);
      print("getJsonRequest " + ex.message);
    }
    return Map();
  }

  /// Obtener un json en PUT
  Future<Map<String, dynamic>> putJsonRequest(String method, dynamic dataValue,
      {String? url, String? tokenValue}) async {
    try {
      Dio client = this.init();
      client.options.baseUrl = url ?? apiUrl;
      final response = await client.put(method,
          data: dataValue,
          options: Options(
            headers: {"Authorization": "Bearer $tokenValue"},
          ));
      if (response.data != null) return json.decode(response.toString());
    } on DioError catch (ex) {
      redirectErrors(ex);
      print("putJsonRequest " + ex.message);
    }
    return Map();
  }

  /// Redireccionar en caso de error
  void redirectErrors(DioError ex) {
    //if(ex.response?.statusCode == 401) Get.toNamed('/signIn');
  }

}

class ApiInterceptors extends Interceptor {}
