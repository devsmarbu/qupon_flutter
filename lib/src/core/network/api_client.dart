import 'package:dio/dio.dart';
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
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
    _dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
    ));
  }

  Dio get dio => _dio;
}
