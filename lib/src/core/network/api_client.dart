import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:qupon/src/core/preferences/pref_store.dart';
import 'package:qupon/src/core/constants/app_strings.dart';
import 'api_endpoints.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({String baseUrl = ApiEndpoints.baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = PrefStore().loadString(AppStrings.keyToken);
        if (token != null && token.isNotEmpty) {
          options.headers.putIfAbsent('Authorization', () => 'Bearer $token');
        }
        return handler.next(options);
      },
    ));
    if (kDebugMode) {
      _dio.interceptors.add(_PrettyJsonInterceptor());
    }
  }

  Dio get dio => _dio;
}

class _PrettyJsonInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln('--> ${options.method} ${options.uri}');
    if (options.headers.isNotEmpty) {
      buffer.writeln('Headers:');
      options.headers.forEach((key, value) => buffer.writeln('  $key: $value'));
    }
    if (options.data != null) {
      buffer.writeln('Request Body:');
      buffer.writeln(_prettyJson(options.data));
    }
    buffer.writeln('--> END ${options.method}');
    
    developer.log(buffer.toString(), name: 'network.request');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln('<-- ${response.statusCode} ${response.requestOptions.uri}');
    if (response.data != null) {
      buffer.writeln('Response Body:');
      buffer.writeln(_prettyJson(response.data));
    }
    buffer.writeln('<-- END HTTP');

    developer.log(buffer.toString(), name: 'network.response');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln('<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}');
    buffer.writeln('Message: ${err.message}');
    if (err.response?.data != null) {
      buffer.writeln('Error Response Body:');
      buffer.writeln(_prettyJson(err.response?.data));
    }
    buffer.writeln('<-- END ERROR');

    developer.log(buffer.toString(), name: 'network.error', error: err);
    super.onError(err, handler);
  }

  String _prettyJson(dynamic data) {
    if (data == null) return '';
    try {
      if (data is String) {
        final decoded = json.decode(data);
        return const JsonEncoder.withIndent('  ').convert(decoded);
      } else if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      }
    } catch (_) {}
    return data.toString();
  }
}
