import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/home_data.dart';
import '../models/home_category.dart';
import '../models/home_coupon.dart';

abstract class HomeRepository {
  Future<HomeData> getHomeData();
  Future<List<HomeCategory>> getCategories();
  Future<List<HomeCoupon>> searchCoupons(String query, {int limit = 8});
}

class HomeRepositoryImpl implements HomeRepository {
  final ApiClient _apiClient;

  HomeRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<HomeCategory>> getCategories() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.categories);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch categories. Status: ${response.statusCode}',
        );
      }

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Empty response from categories API');
      }

      final list = responseData as List<dynamic>;
      return list.map((item) {
        final itemMap = item as Map<String, dynamic>;
        return HomeCategory.fromJson(itemMap);
      }).toList();
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Network error while fetching categories';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

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

  @override
  Future<List<HomeCoupon>> searchCoupons(String query, {int limit = 8}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.search,
        queryParameters: {
          'q': query,
          'limit': limit,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch search results. Status: ${response.statusCode}',
        );
      }

      final responseData = response.data;
      if (responseData == null) {
        return [];
      }

      final dataMap = responseData['data'] as Map<String, dynamic>?;
      if (dataMap == null) {
        return [];
      }

      final couponsList = dataMap['coupons'] as List<dynamic>?;
      if (couponsList == null) {
        return [];
      }

      return couponsList.map((item) {
        final itemMap = item as Map<String, dynamic>;
        return HomeCoupon.fromJson(itemMap);
      }).toList();
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Network error during search';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
