class DashboardCoupon {
  final String vendor;
  final String offer;
  final String code;
  final String couponUrl;
  final String price; // e.g., "QAR 20"
  final String status;
  final String redeemBy;
  final int? daysUntilRedeem;

  DashboardCoupon({
    required this.vendor,
    required this.offer,
    required this.code,
    required this.couponUrl,
    required this.price,
    required this.status,
    required this.redeemBy,
    this.daysUntilRedeem,
  });

  factory DashboardCoupon.fromJson(Map<String, dynamic> json) {
    final codeVal = json['code']?.toString() ?? 
                    json['couponCode']?.toString() ?? 
                    json['coupon_code']?.toString() ?? 
                    '';

    String priceVal = '';
    final rawPrice = json['price'] ?? json['amount'];
    if (rawPrice != null) {
      if (rawPrice is num) {
        final formattedAmount = rawPrice % 1 == 0 ? rawPrice.toInt().toString() : rawPrice.toStringAsFixed(2);
        priceVal = 'QAR $formattedAmount';
      } else {
        final priceStr = rawPrice.toString();
        if (priceStr.contains('QAR')) {
          priceVal = priceStr;
        } else {
          priceVal = 'QAR $priceStr';
        }
      }
    }

    final int? daysUntilRedeemVal = json['daysUntilRedeem'] is num 
        ? (json['daysUntilRedeem'] as num).toInt() 
        : int.tryParse(json['daysUntilRedeem']?.toString() ?? '');

    return DashboardCoupon(
      vendor: json['vendor']?.toString() ?? json['vendorName']?.toString() ?? json['vendor_name']?.toString() ?? '',
      offer: json['offer']?.toString() ?? 
             json['offerName']?.toString() ?? 
             json['offer_name']?.toString() ?? 
             json['couponName']?.toString() ?? 
             json['coupon_name']?.toString() ?? 
             json['title']?.toString() ?? 
             json['name']?.toString() ?? 
             '',
      code: codeVal,
      couponUrl: json['couponUrl']?.toString() ?? json['coupon_url']?.toString() ?? json['url']?.toString() ?? '',
      price: priceVal,
      status: json['status']?.toString() ?? json['status_name']?.toString() ?? json['state']?.toString() ?? '',
      redeemBy: json['redeemBy']?.toString() ?? json['redeem_by']?.toString() ?? json['expiryDate']?.toString() ?? json['expiry_date']?.toString() ?? json['validity']?.toString() ?? json['validUntil']?.toString() ?? '',
      daysUntilRedeem: daysUntilRedeemVal,
    );
  }
}

class DashboardTransaction {
  final String id;
  final String orderDisplayRef;
  final String title;
  final String date;
  final String price; // Formatted price, e.g., "-QAR 85" or "+QAR 25"
  final String type; // e.g., 'grocery', 'redeemed', 'coffee', or 'other'
  final int couponsCount;
  final String vendor;
  final String offer;
  final String code;
  final String couponUrl;
  final String status;
  final String redeemBy;
  final List<DashboardCoupon> coupons;

  DashboardTransaction({
    required this.id,
    required this.orderDisplayRef,
    required this.title,
    required this.date,
    required this.price,
    required this.type,
    required this.couponsCount,
    required this.vendor,
    required this.offer,
    required this.code,
    required this.couponUrl,
    required this.status,
    required this.redeemBy,
    required this.coupons,
  });

  factory DashboardTransaction.fromJson(Map<String, dynamic> json) {
    String rawPrice = json['price']?.toString() ?? '';
    if (rawPrice.isEmpty) {
      final amount = json['amount'] ?? 0.0;
      final isCredit = json['isCredit'] ?? (json['type'] == 'redeemed' || json['type'] == 'credit');
      rawPrice = '${isCredit ? '+' : '-'}QAR $amount';
    }

    int coupons = 1;
    final rawCoupons = json['couponsCount'] ?? json['coupons_count'] ?? json['coupons'] ?? json['couponCount'] ?? json['coupon_count'] ?? json['items'];
    if (rawCoupons != null) {
      if (rawCoupons is List) {
        coupons = rawCoupons.length;
      } else {
        coupons = int.tryParse(rawCoupons.toString()) ?? 1;
      }
    }

    final codeVal = json['code']?.toString() ?? 
                    json['couponCode']?.toString() ?? 
                    json['coupon_code']?.toString() ?? 
                    (json['coupon'] is Map ? json['coupon']['code']?.toString() : null) ?? 
                    '';

    String? displayRef = json['orderDisplayRef']?.toString() ??
                         json['order_display_ref']?.toString();

    if (displayRef == null && json['order'] is Map) {
      displayRef = json['order']['orderDisplayRef']?.toString() ??
                   json['order']['order_display_ref']?.toString();
    }

    if (displayRef == null) {
      displayRef = json['orderId']?.toString() ??
                   json['order_id']?.toString();
    }

    if (displayRef == null && json['order'] is Map) {
      displayRef = json['order']['orderId']?.toString() ??
                   json['order']['order_id']?.toString() ??
                   json['order']['id']?.toString();
    }

    final orderDisplayRefVal = displayRef ?? json['id']?.toString() ?? '';

    final List<DashboardCoupon> parsedCoupons = [];
    final rawCouponsList = json['coupons'] ?? json['items'];
    if (rawCouponsList is List) {
      for (final c in rawCouponsList) {
        if (c is Map<String, dynamic>) {
          parsedCoupons.add(DashboardCoupon.fromJson(c));
        }
      }
    }

    if (parsedCoupons.isEmpty) {
      final priceWithoutPrefix = rawPrice.replaceAll('+', '').replaceAll('-', '');
      parsedCoupons.add(DashboardCoupon(
        vendor: json['vendor']?.toString() ?? json['vendorName']?.toString() ?? json['vendor_name']?.toString() ?? '',
        offer: json['offer']?.toString() ?? 
               json['offerName']?.toString() ?? 
               json['offer_name']?.toString() ?? 
               json['couponName']?.toString() ?? 
               json['coupon_name']?.toString() ?? 
               json['title']?.toString() ?? 
               json['name']?.toString() ?? 
               '',
        code: codeVal,
        couponUrl: json['couponUrl']?.toString() ?? json['coupon_url']?.toString() ?? json['url']?.toString() ?? '',
        price: priceWithoutPrefix,
        status: json['status']?.toString() ?? json['status_name']?.toString() ?? json['state']?.toString() ?? '',
        redeemBy: json['redeemBy']?.toString() ?? json['redeem_by']?.toString() ?? json['expiryDate']?.toString() ?? json['expiry_date']?.toString() ?? json['validity']?.toString() ?? json['validUntil']?.toString() ?? '',
        daysUntilRedeem: json['daysUntilRedeem'] is num ? (json['daysUntilRedeem'] as num).toInt() : int.tryParse(json['daysUntilRedeem']?.toString() ?? ''),
      ));
    }

    String finalVendor = json['vendor']?.toString() ?? json['vendorName']?.toString() ?? json['vendor_name']?.toString() ?? '';
    if (finalVendor.isEmpty && parsedCoupons.isNotEmpty) {
      finalVendor = parsedCoupons.first.vendor;
    }

    String finalOffer = json['offer']?.toString() ?? json['offerName']?.toString() ?? json['offer_name']?.toString() ?? '';
    if (finalOffer.isEmpty && parsedCoupons.isNotEmpty) {
      finalOffer = parsedCoupons.first.offer;
    }

    String finalCode = codeVal;
    if (finalCode.isEmpty && parsedCoupons.isNotEmpty) {
      finalCode = parsedCoupons.first.code;
    }

    String finalCouponUrl = json['couponUrl']?.toString() ?? json['coupon_url']?.toString() ?? json['url']?.toString() ?? '';
    if (finalCouponUrl.isEmpty && parsedCoupons.isNotEmpty) {
      finalCouponUrl = parsedCoupons.first.couponUrl;
    }

    String finalStatus = json['status']?.toString() ?? json['status_name']?.toString() ?? json['state']?.toString() ?? '';
    if (finalStatus.isEmpty && parsedCoupons.isNotEmpty) {
      finalStatus = parsedCoupons.first.status;
    }

    String finalRedeemBy = json['redeemBy']?.toString() ?? json['redeem_by']?.toString() ?? json['expiryDate']?.toString() ?? json['expiry_date']?.toString() ?? json['validity']?.toString() ?? json['validUntil']?.toString() ?? '';
    if (finalRedeemBy.isEmpty && parsedCoupons.isNotEmpty) {
      finalRedeemBy = parsedCoupons.first.redeemBy;
    }

    return DashboardTransaction(
      id: json['id']?.toString() ?? orderDisplayRefVal,
      orderDisplayRef: orderDisplayRefVal,
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      date: json['date']?.toString() ?? json['createdAt']?.toString() ?? json['created_at']?.toString() ?? json['addedAt']?.toString() ?? '',
      price: rawPrice,
      type: json['type']?.toString() ?? 'other',
      couponsCount: coupons,
      vendor: finalVendor,
      offer: finalOffer,
      code: finalCode,
      couponUrl: finalCouponUrl,
      status: finalStatus,
      redeemBy: finalRedeemBy,
      coupons: parsedCoupons,
    );
  }
}

class DashboardData {
  final double totalSpent;
  final int couponsUsed;
  final double totalSaved;
  final int activeCoupons;
  final double wallet;
  final List<DashboardTransaction> transactions;

  DashboardData({
    required this.totalSpent,
    required this.couponsUsed,
    required this.totalSaved,
    required this.activeCoupons,
    required this.wallet,
    required this.transactions,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    // If the response is wrapped in a 'data' key, unwrap it.
    final data = json['data'] as Map<String, dynamic>? ?? json;

    final rawTransactions = data['orders'] as List<dynamic>? ??
                             data['transactions'] as List<dynamic>? ??
                             data['history'] as List<dynamic>? ??
                             data['deals'] as List<dynamic>? ??
                             [];
    final transactions = rawTransactions
        .whereType<Map<String, dynamic>>()
        .map((t) => DashboardTransaction.fromJson(t))
        .toList();

    final stats = data['stats'] as Map<String, dynamic>?;

    final totalSpentVal = stats?['totalSpent'] ?? stats?['total_spent'] ?? data['totalSpent'] ?? data['total_spent'];
    final couponsUsedVal = stats?['couponCount'] ?? stats?['couponsUsed'] ?? stats?['coupons_used'] ?? data['couponsUsed'] ?? data['coupons_used'];
    final totalSavedVal = stats?['totalSaved'] ?? stats?['total_saved'] ?? data['totalSaved'] ?? data['total_saved'];
    final activeCouponsVal = stats?['pendingItems'] ?? stats?['activeCoupons'] ?? stats?['active_coupons'] ?? data['activeCoupons'] ?? data['active_coupons'];
    final walletVal = stats?['walletBalance'] ?? stats?['wallet_balance'] ?? stats?['wallet'] ?? data['wallet'];

    return DashboardData(
      totalSpent: (totalSpentVal as num?)?.toDouble() ?? 0.0,
      couponsUsed: int.tryParse(couponsUsedVal?.toString() ?? '') ?? 0,
      totalSaved: (totalSavedVal as num?)?.toDouble() ?? 0.0,
      activeCoupons: int.tryParse(activeCouponsVal?.toString() ?? '') ?? 0,
      wallet: (walletVal as num?)?.toDouble() ?? 0.0,
      transactions: transactions,
    );
  }
}
