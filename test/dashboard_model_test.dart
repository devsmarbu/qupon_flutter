import 'package:flutter_test/flutter_test.dart';
import 'package:qupon/src/features/account/data/models/dashboard_model.dart';

void main() {
  group('DashboardTransaction.fromJson Tests', () {
    test('should prioritize top-level orderDisplayRef over orderId and id', () {
      final json = {
        'id': 'tx_12345',
        'orderId': 'order_999',
        'orderDisplayRef': 'QP-2026-ABCD',
        'title': 'Test Transaction',
        'date': '2026-08-06',
        'amount': 100.0,
      };

      final transaction = DashboardTransaction.fromJson(json);

      expect(transaction.orderDisplayRef, 'QP-2026-ABCD');
    });

    test('should prioritize nested orderDisplayRef over nested orderId and nested id', () {
      final json = {
        'id': 'tx_12345',
        'order': {
          'id': 'order_id_nested_123',
          'orderId': 'order_999',
          'orderDisplayRef': 'QP-NESTED-XYZ',
        },
        'title': 'Test Transaction',
        'date': '2026-08-06',
        'amount': 100.0,
      };

      final transaction = DashboardTransaction.fromJson(json);

      expect(transaction.orderDisplayRef, 'QP-NESTED-XYZ');
    });

    test('should fall back to orderId/order_id/id if orderDisplayRef is not present', () {
      final json = {
        'id': 'tx_12345',
        'orderId': 'order_999',
        'title': 'Test Transaction',
        'date': '2026-08-06',
        'amount': 100.0,
      };

      final transaction = DashboardTransaction.fromJson(json);

      expect(transaction.orderDisplayRef, 'order_999');
    });

    test('should fall back to id if no other fields are present', () {
      final json = {
        'id': 'tx_12345',
        'title': 'Test Transaction',
        'date': '2026-08-06',
        'amount': 100.0,
      };

      final transaction = DashboardTransaction.fromJson(json);

      expect(transaction.orderDisplayRef, 'tx_12345');
    });

    test('should prioritize top-level orderDisplayRef even if nested order only has id', () {
      final json = {
        'id': 'tx_12345',
        'orderDisplayRef': 'TG1-3-T-9-57',
        'order': {
          'id': 'nested_order_id_64db3',
        },
        'title': 'Test Transaction',
        'date': '2026-08-06',
        'amount': 100.0,
      };

      final transaction = DashboardTransaction.fromJson(json);

      expect(transaction.orderDisplayRef, 'TG1-3-T-9-57');
    });
  });

  group('DashboardData.fromJson and nested items Tests', () {
    test('should parse dashboard json prioritizing orders over transactions and mapping items correctly', () {
      final json = {
        'orders': [
          {
            'orderNumber': 57,
            'orderDisplayRef': 'TG1-3-T-9-57',
            'date': '2026-08-05T09:58:39.664Z',
            'amount': 50,
            'id': '6a73094ffab55e8ebe6942ec',
            'items': [
              {
                'orderId': '6a73094ffab55e8ebe6942ec',
                'price': 20,
                'couponCode': 'C-S6BP',
                'couponName': 'Tech Gadgets 15% — Basic',
                'vendorName': 'ElectroWorld',
                'couponUrl': 'https://qupon.marbu.in/coupon/RAHRD4RE',
                'redeemBy': '2026-11-30T23:59:59.999Z',
                'status': 'pending',
                'daysUntilRedeem': 117,
              }
            ]
          }
        ],
        'transactions': [
          {
            'type': 'debit',
            'amount': 50,
            'date': '2026-08-05T10:01:29.165Z',
            'id': '6a7309f9fab55e8ebe6942f4',
          }
        ],
        'stats': {
          'totalSpent': 70,
          'totalSaved': 50,
          'couponCount': 3,
          'pendingItems': 3,
        }
      };

      final data = DashboardData.fromJson(json);

      // Verify stats
      expect(data.totalSpent, 70.0);
      expect(data.totalSaved, 50.0);
      expect(data.couponsUsed, 3);
      expect(data.activeCoupons, 3);

      // Verify that data.transactions lists orders first (due to orders prioritization)
      expect(data.transactions.length, 1);
      final firstTx = data.transactions.first;

      // Verify order details mapped to transaction properties
      expect(firstTx.id, '6a73094ffab55e8ebe6942ec');
      expect(firstTx.orderDisplayRef, 'TG1-3-T-9-57');
      expect(firstTx.couponsCount, 1);
      expect(firstTx.vendor, 'ElectroWorld');
      expect(firstTx.offer, 'Tech Gadgets 15% — Basic');
      expect(firstTx.code, 'C-S6BP');

      // Verify nested coupon items
      expect(firstTx.coupons.length, 1);
      expect(firstTx.coupons.first.offer, 'Tech Gadgets 15% — Basic');
      expect(firstTx.coupons.first.vendor, 'ElectroWorld');
      expect(firstTx.coupons.first.daysUntilRedeem, 117);
    });
  });
}
