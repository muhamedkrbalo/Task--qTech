import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:step_counter/core/constants/constants.dart';
import 'package:step_counter/core/network/app_interceptors.dart';
import 'package:step_counter/core/service_locator/service_locator.dart';
import 'api_consumer.dart';

class DioConsumer implements ApiConsumer {
  final Dio client;

  DioConsumer({required this.client}) {
    client.options
      ..baseUrl = Constants.baseUrl
      ..followRedirects = false;
    client.interceptors.add(getIt<AppInterceptors>());
    if (kDebugMode) {
      client.interceptors.addAll(
        kDebugMode
            ? [
                PrettyDioLogger(
                  requestHeader: true,
                  requestBody: true,
                  responseBody: true,
                  responseHeader: false,
                  compact: false,
                  error: true,
                  request: true,
                ),
              ]
            : [],
      );
    }
  }

  @override
  Future get(String path, {Map<String, dynamic>? queryParameters}) async {
    final response = await client.get(path, queryParameters: queryParameters);
    return response.data;
  }

  @override
  Future post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool? isFormData,
  }) async {
    var response = await client.post(
      path,
      data: isFormData == true ? FormData.fromMap(body!) : body,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  @override
  Future put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool? isFormData,
  }) async {
    final response = await client.put(
      path,
      data: isFormData == true ? FormData.fromMap(body!) : body,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  @override
  Future delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool? isFormData,
  }) async {
    final response = await client.delete(
      path,
      data: isFormData == true ? FormData.fromMap(body!) : body,
      queryParameters: queryParameters,
    );
    return response.data;
  }
}
