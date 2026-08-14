import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/offer.dart';
import '../models/offer_option.dart';
import '../models/vendor_details.dart';

abstract class OffersRepository {
  Future<List<Offer>> getOffers();
  Future<List<Offer>> getCategoryOffers(String categoryId);
  Future<Offer> getCouponDetails(String slug);
  Future<String?> submitCouponRequest({required Map<String, dynamic> body});
  Future<bool> toggleWishlist({required String couponId});
}

class OffersRepositoryImpl implements OffersRepository {
  final ApiClient _apiClient;

  OffersRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<Offer>> getCategoryOffers(String categoryId) async {
    try {
      final response = await _apiClient.dio.get('${ApiEndpoints.categoryDetail}$categoryId');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch category offers. Status: ${response.statusCode}',
        );
      }

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Empty response from category API');
      }

      final data = responseData['data'] as Map<String, dynamic>?;
      if (data == null) {
        return [];
      }

      final couponsList = data['coupons'] as List<dynamic>? ?? [];
      return couponsList.map((c) {
        final couponMap = c as Map<String, dynamic>;

        // Calculate time left from validity date
        final validityStr = couponMap['validity']?.toString() ?? '';
        int daysLeft = 0;
        int hoursLeft = 0;
        int minutesLeft = 0;
        try {
          final expiry = DateTime.parse(validityStr);
          final diff = expiry.difference(DateTime.now());
          daysLeft = diff.inDays.clamp(0, 9999);
          hoursLeft = (diff.inHours % 24).clamp(0, 23);
          minutesLeft = (diff.inMinutes % 60).clamp(0, 59);
        } catch (_) {}

        // Inject computed time fields before calling fromJson
        final enriched = Map<String, dynamic>.from(couponMap)
          ..['daysLeft'] = daysLeft
          ..['hoursLeft'] = hoursLeft
          ..['minutesLeft'] = minutesLeft
          ..['validity'] = '${daysLeft}d${hoursLeft}h${minutesLeft}m left';

        return Offer.fromJson(enriched);
      }).toList();
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Network error while fetching category offers';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Offer>> getOffers() async {
    // Simulate API network delay
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      const Offer(
        id: '1',
        title: 'Velero Hotel Doha Lusail',
        category: 'Food & Drinks',
        imageUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?auto=format&fit=crop&w=800&q=80',
        daysLeft: 7,
        hoursLeft: 14,
        minutesLeft: 36,
        location: 'Velero Hotel Doha Lusail',
        description: 'FRIDAY BRUNCH WITH POOL ACCESS',
        price: 99.0,
        currency: 'QAR',
      ),
      const Offer(
        id: '2',
        title: 'Paws',
        category: 'Animal Care',
        imageUrl: 'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?auto=format&fit=crop&w=800&q=80',
        daysLeft: 5,
        hoursLeft: 12,
        minutesLeft: 20,
        location: 'Al Gharafa, Doha',
        description: 'CAT BATH & HAIRCUT',
        price: 150.0,
        currency: 'QAR',
      ),
      const Offer(
        id: '3',
        title: 'The Burger Boutique',
        category: 'Food & Drinks',
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=800&q=80',
        daysLeft: 3,
        hoursLeft: 6,
        minutesLeft: 15,
        location: 'The Pearl-Qatar, Doha',
        description: 'DOUBLE CHEESEBURGER COMBO MEAL',
        price: 45.0,
        currency: 'QAR',
      ),
      const Offer(
        id: '4',
        title: 'Royal Pets Grooming',
        category: 'Animal Care',
        imageUrl: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?auto=format&fit=crop&w=800&q=80',
        daysLeft: 12,
        hoursLeft: 8,
        minutesLeft: 45,
        location: 'West Bay, Doha',
        description: 'PREMIUM PET GROOMING & SPA',
        price: 199.0,
        currency: 'QAR',
      ),
      const Offer(
        id: '5',
        title: 'Tech Gadgets 15%',
        category: 'Electronics',
        imageUrl: 'https://images.unsplash.com/photo-1531297484001-80022131f5a1?auto=format&fit=crop&w=800&q=80',
        daysLeft: 152,
        hoursLeft: 15,
        minutesLeft: 32,
        location: '123 Tech Avenue, Silicon Valley, CA 94025',
        description: 'Upgrade your tech arsenal with 15% off smart home devices, headphones, and more.',
        price: 20.0,
        currency: 'QAR',
      ),
      const Offer(
        id: '6',
        title: 'Laptop Accessories',
        category: 'Electronics',
        imageUrl: '',
        daysLeft: 156,
        hoursLeft: 14,
        minutesLeft: 3,
        location: '123 Tech Avenue, Silicon Valley, CA 94025',
        description: 'Laptop Sleeve',
        price: 5.0,
         currency: 'QAR',
      ),
    ];
  }

  @override
  Future<Offer> getCouponDetails(String slug) async {
    try {
      final response = await _apiClient.dio.get('/api/storefront/coupons/$slug');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch coupon details. Status: ${response.statusCode}',
        );
      }

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Empty response from coupon details API');
      }

      final Map<String, dynamic> couponMap;
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        couponMap = responseData['data'] as Map<String, dynamic>;
      } else {
        couponMap = responseData as Map<String, dynamic>;
      }

      // Calculate time left from validity date
      final validityStr = couponMap['validity']?.toString() ?? '';
      int daysLeft = 0;
      int hoursLeft = 0;
      int minutesLeft = 0;
      try {
        final expiry = DateTime.parse(validityStr);
        final diff = expiry.difference(DateTime.now());
        daysLeft = diff.inDays.clamp(0, 9999);
        hoursLeft = (diff.inHours % 24).clamp(0, 23);
        minutesLeft = (diff.inMinutes % 60).clamp(0, 59);
      } catch (_) {}

      final enriched = Map<String, dynamic>.from(couponMap)
        ..['daysLeft'] = daysLeft
        ..['hoursLeft'] = hoursLeft
        ..['minutesLeft'] = minutesLeft
        ..['validity'] = '${daysLeft}d${hoursLeft}h${minutesLeft}m left'
        ..['slug'] = couponMap['slug']?.toString() ?? slug;

      return Offer.fromJson(enriched);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Network error while fetching coupon details';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String?> submitCouponRequest({required Map<String, dynamic> body}) async {
    try {
      final response = await _apiClient.dio.post('/api/coupon-requests', data: body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to submit coupon request. Status: ${response.statusCode}',
        );
      }
      return response.data?['message']?.toString();
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Network error while submitting coupon request';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> toggleWishlist({required String couponId}) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.wishlist,
        data: {
          'couponId': couponId,
          'toggle': true,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update wishlist. Status: ${response.statusCode}',
        );
      }

      final responseData = response.data;
      if (responseData is Map && responseData['wishlisted'] is bool) {
        return responseData['wishlisted'] as bool;
      }
      return true;
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.message ??
          'Network error while updating wishlist';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

