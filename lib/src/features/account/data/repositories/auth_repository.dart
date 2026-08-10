import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/preferences/pref_store.dart';
import '../../../../core/constants/app_strings.dart';
import '../models/profile_data.dart';
import '../models/dashboard_model.dart';
import '../../../home/data/models/home_coupon.dart';

abstract class AuthRepository {
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String role,
    String recaptchaToken = '',
  });

  Future<void> login({
    required String email,
    required String password,
    required String role,
  });

  Future<void> verifyOtp({
    required String email,
    required String otp,
    required String role,
  });

  Future<void> resendOtp({
    required String email,
    required String role,
    String recaptchaToken = '',
  });

  Future<void> forgotPassword({
    required String phoneNumber,
    required String role,
  });

  Future<DashboardData> getDashboard({required String token});

  Future<List<HomeCoupon>> getWishlist({required String token});
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String role,
    String recaptchaToken = '',
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'role': role,
          'name': name,
          'phoneNumber': phoneNumber,
          'recaptchaToken': recaptchaToken,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to register. Server returned code ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      final errorMessage = (data is Map ? data['message'] : null) ?? e.message ?? 'Unknown network error occurred';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
          'role': role,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to login. Server returned code ${response.statusCode}',
        );
      }

      final responseData = response.data;
      if (responseData != null && responseData['success'] == true) {
        final data = responseData['data'];
        if (data != null) {
          final token = data['token'];
          final user = data['user'];
          if (token != null) {
            await PrefStore().saveString(AppStrings.keyToken, token.toString());
          }
          if (user != null) {
            await PrefStore.saveProfile(
              ProfileData(
                id: user['id']?.toString() ?? '',
                role: user['role']?.toString() ?? '',
                email: user['email']?.toString() ?? '',
                name: user['name']?.toString() ?? '',
              ),
            );
          }
        }
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      final errorMessage = (data is Map ? data['message'] : null) ?? e.message ?? 'Unknown network error occurred';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> verifyOtp({
    required String email,
    required String otp,
    required String role,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.verifyOtp,
        data: {
          'email': email,
          'otp': otp,
          'role': role,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to verify OTP. Server returned code ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      final errorMessage = (data is Map ? data['message'] : null) ?? e.message ?? 'Unknown network error occurred';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> resendOtp({
    required String email,
    required String role,
    String recaptchaToken = '',
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.resendOtp,
        data: {
          'email': email,
          'role': role,
          'recaptchaToken': recaptchaToken,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to resend OTP. Server returned code ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      final errorMessage = (data is Map ? data['message'] : null) ?? e.message ?? 'Unknown network error occurred';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> forgotPassword({
    required String phoneNumber,
    required String role,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.forgotPassword,
        data: {
          'phoneNumber': phoneNumber,
          'role': role,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to send reset link. Server returned code ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      final errorMessage = (data is Map ? data['message'] : null) ?? e.message ?? 'Unknown network error occurred';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<DashboardData> getDashboard({required String token}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.dashboard,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch dashboard data. Status: ${response.statusCode}',
        );
      }

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Empty response from dashboard API');
      }

      return DashboardData.fromJson(responseData);
    } on DioException catch (e) {
      final data = e.response?.data;
      final errorMessage = (data is Map ? data['message'] : null) ?? e.message ?? 'Unknown network error occurred';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<HomeCoupon>> getWishlist({required String token}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.wishlist,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        return [];
      }

      final responseData = response.data;
      if (responseData == null) {
        return [];
      }

      final List<HomeCoupon> items = [];
      HomeCoupon createWishlistCoupon(Map<String, dynamic> couponMap) {
        final coupon = HomeCoupon.fromJson(couponMap);
        return HomeCoupon(
          id: coupon.id,
          name: coupon.name,
          nameAr: coupon.nameAr,
          vendor: coupon.vendor,
          discount: coupon.discount,
          price: coupon.price,
          actualPrice: coupon.actualPrice,
          validity: coupon.validity,
          category: coupon.category,
          description: coupon.description,
          descriptionAr: coupon.descriptionAr,
          imageUrl: coupon.imageUrl,
          slug: coupon.slug,
          vendorId: coupon.vendorId,
          wishlisted: coupon.wishlisted ?? true,
        );
      }

      if (responseData is Map && responseData['items'] is List) {
        for (var item in responseData['items']) {
          if (item is Map && item['coupon'] is Map<String, dynamic>) {
            items.add(createWishlistCoupon(item['coupon'] as Map<String, dynamic>));
          } else if (item is Map) {
            items.add(createWishlistCoupon(Map<String, dynamic>.from(item)));
          }
        }
      } else if (responseData is List) {
        for (var item in responseData) {
          if (item is Map && item['coupon'] is Map<String, dynamic>) {
            items.add(createWishlistCoupon(item['coupon'] as Map<String, dynamic>));
          } else if (item is Map) {
            items.add(createWishlistCoupon(Map<String, dynamic>.from(item)));
          }
        }
      }
      return items;
    } catch (_) {
      return [];
    }
  }
}

