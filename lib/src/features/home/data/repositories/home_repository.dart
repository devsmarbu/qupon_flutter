import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/home_data.dart';

abstract class HomeRepository {
  Future<HomeData> getHomeData();
}

class HomeRepositoryImpl implements HomeRepository {
  final ApiClient _apiClient;

  HomeRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<HomeData> getHomeData() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.storefrontHome);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch home data. Status: ${response.statusCode}',
        );
      }

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Empty response from home API');
      }

      final data = responseData is Map<String, dynamic>
          ? responseData
          : Map<String, dynamic>.from(responseData as Map);

      return HomeData.fromJson(data);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Network error while fetching home data';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
