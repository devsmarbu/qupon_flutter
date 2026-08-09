import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/api_cart_model.dart';
import '../models/checkout_model.dart';
import '../models/payment_gateway.dart';

abstract class CartRepository {
  Future<ApiCartData> getCart(List<Map<String, String>> items);
  Future<ApiCartData> addToCart(String couponId, String variantId);
  Future<ApiCartData> removeFromCart(String key);
  Future<List<PaymentGateway>> getPaymentGateways();
  Future<CheckoutResponse> checkout(CheckoutRequest request);
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
      final responseData = e.response?.data;
      final msg = (responseData is Map ? responseData['message'] : null) ??
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
      final responseData = e.response?.data;
      final msg = (responseData is Map ? responseData['message'] : null) ??
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
      final responseData = e.response?.data;
      final msg = (responseData is Map ? responseData['message'] : null) ??
          e.message ??
          'Network error while removing from cart';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<PaymentGateway>> getPaymentGateways() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.paymentGateways);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch payment gateways. Status: ${response.statusCode}',
        );
      }

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Empty response from payment gateways API');
      }

      // The API returns the array directly (or inside a data key)
      final List<dynamic> list = responseData is List
          ? responseData
          : (responseData['data'] as List? ?? []);

      return list.map((e) => PaymentGateway.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      final responseData = e.response?.data;
      final msg = (responseData is Map ? responseData['message'] : null) ??
          e.message ??
          'Network error while fetching payment gateways';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CheckoutResponse> checkout(CheckoutRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.checkout,
        data: request.toJson(),
      );

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Empty response from checkout API');
      }

      return CheckoutResponse.fromJson(responseData as Map<String, dynamic>);
    } on DioException catch (e) {
      // API returns { "ok": false, "error": "..." } on failure
      final data = e.response?.data;
      final msg = (data is Map ? (data['error'] ?? data['message']) : null) ??
          e.message ??
          'Network error during checkout';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
