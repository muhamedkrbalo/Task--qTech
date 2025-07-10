import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppInterceptors extends Interceptor {
  AppInterceptors();
  static bool isInternet = true;
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    isInternet = true;
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');

    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    // // Check internet connectivity before sending request
    // if (!await CommonMethods.hasConnection()) {
    //   isInternet = false;
    //   return handler.reject(
    //     DioException(
    //       requestOptions: options,
    //       error: 'No Internet Connection',
    //       type: DioExceptionType.connectionError,
    //     ),
    //   );
    // }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }
}
