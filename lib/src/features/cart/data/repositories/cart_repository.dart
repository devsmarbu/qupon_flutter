import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/api_cart_model.dart';

abstract class CartRepository {
  Future<ApiCartData> getCart(List<Map<String, String>> items);
  Future<ApiCartData> addToCart(String couponId, String variantId);
  Future<ApiCartData> removeFromCart(String key);
}

class CartRepositoryImpl implements CartRepository {
  final ApiClient _apiClient;

  CartRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<ApiCartData> getCart(List<Map<String, String>> items) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.cart,
        data: {'items': items},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch cart. Status: ${response.statusCode}',
        );
      }

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Empty response from cart API');
      }

      final apiResponse = ApiCartResponse.fromJson(responseData);
      return apiResponse.data;
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Network error while fetching cart';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<ApiCartData> addToCart(String couponId, String variantId) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.cart,
        data: {
          'items': [
            {
              'couponId': couponId,
              'variantId': variantId,
            }
          ]
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to add item to cart. Status: ${response.statusCode}',
        );
      }

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Empty response from cart API');
      }

      final apiResponse = ApiCartResponse.fromJson(responseData);
      return apiResponse.data;
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Network error while adding to cart';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<ApiCartData> removeFromCart(String key) async {
    try {
      final response = await _apiClient.dio.delete(
        ApiEndpoints.cart,
        data: {
          'key': key,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to remove item from cart. Status: ${response.statusCode}',
        );
      }

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Empty response from cart API');
      }

      final apiResponse = ApiCartResponse.fromJson(responseData);
      return apiResponse.data;
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Network error while removing from cart';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
