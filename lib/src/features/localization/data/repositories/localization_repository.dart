import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

abstract class LocalizationRepository {
  Future<Map<String, String>> getLabels(int langId);
}

class LocalizationRepositoryImpl implements LocalizationRepository {
  final ApiClient _apiClient;

  LocalizationRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Map<String, String>> getLabels(int langId) async {
    final url = '${ApiEndpoints.storefrontLabels}$langId';
    debugPrint('[LocalizationRepo] Fetching labels from: ${ApiEndpoints.baseUrl}$url');
    try {
      final response = await _apiClient.dio.get(url);

      debugPrint('[LocalizationRepo] Response status: ${response.statusCode}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch labels. Status: ${response.statusCode}',
        );
      }

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Empty response from labels API');
      }

      Map<String, dynamic>? dataMap;
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data') && responseData['data'] is Map<String, dynamic>) {
          dataMap = responseData['data'] as Map<String, dynamic>;
        } else {
          dataMap = responseData;
        }
      }

      if (dataMap != null) {
        final labels = dataMap.map((key, value) => MapEntry(key, value.toString()));
        debugPrint('[LocalizationRepo] Loaded ${labels.length} labels for langId=$langId');
        return labels;
      }
      throw Exception('Unexpected response format from labels API');
    } on DioException catch (e) {
      debugPrint('[LocalizationRepo] DioException fetching labels: ${e.message}');
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Network error while fetching storefront labels';
      throw Exception(msg);
    } catch (e) {
      debugPrint('[LocalizationRepo] Error fetching labels: $e');
      rethrow;
    }
  }
}

