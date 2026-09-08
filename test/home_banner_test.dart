import 'package:flutter_test/flutter_test.dart';
import 'package:qupon/src/features/home/data/models/home_banner.dart';

void main() {
  group('HomeBanner Tests', () {
    test('parses couponId when explicitly provided in json (couponId)', () {
      final json = {
        'id': 'banner_1',
        'couponId': 'coupon_99',
        'title': 'Test Banner',
        'subtitle': 'Sub',
        'image': 'https://example.com/banner.png'
      };

      final banner = HomeBanner.fromJson(json);
      expect(banner.id, equals('banner_1'));
      expect(banner.couponId, equals('coupon_99'));
    });

    test('parses coupon_id when provided in snake_case', () {
      final json = {
        'id': 'banner_2',
        'coupon_id': 'coupon_88',
        'title': 'Snake Case Banner',
      };

      final banner = HomeBanner.fromJson(json);
      expect(banner.id, equals('banner_2'));
      expect(banner.couponId, equals('coupon_88'));
    });

    test('parses coupon object id when coupon is a Map', () {
      final json = {
        'id': 'banner_3',
        'coupon': {'id': 'coupon_77', 'name': 'Sub Coupon'},
        'title': 'Map Coupon Banner',
      };

      final banner = HomeBanner.fromJson(json);
      expect(banner.id, equals('banner_3'));
      expect(banner.couponId, equals('coupon_77'));
    });

    test('couponId is null when not provided', () {
      final json = {
        'id': 'banner_4',
        'title': 'No Coupon Banner',
      };

      final banner = HomeBanner.fromJson(json);
      expect(banner.id, equals('banner_4'));
      expect(banner.couponId, isNull);
    });
  });
}
