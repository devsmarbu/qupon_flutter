class ApiCartResponse {
  final bool success;
  final int statusCode;
  final String message;
  final ApiCartData data;

  ApiCartResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ApiCartResponse.fromJson(Map<String, dynamic> json) {
    return ApiCartResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: ApiCartData.fromJson(json['data'] ?? {}),
    );
  }
}

class ApiCartData {
  final List<ApiCartItem> items;
  final List<dynamic> unavailable;
  final ApiCartTotals totals;

  ApiCartData({
    required this.items,
    required this.unavailable,
    required this.totals,
  });

  factory ApiCartData.fromJson(Map<String, dynamic> json) {
    return ApiCartData(
      items: (json['items'] as List?)
              ?.map((item) => ApiCartItem.fromJson(item))
              .toList() ??
          [],
      unavailable: json['unavailable'] ?? [],
      totals: ApiCartTotals.fromJson(json['totals'] ?? {}),
    );
  }
}

class ApiCartItem {
  final String key;
  final String couponId;
  final String variantId;
  final String addedAt;
  final String name;
  final String nameAr;
  final String vendor;
  final double payable;
  final double listPrice;
  final String discount;
  final bool expired;

  ApiCartItem({
    required this.key,
    required this.couponId,
    required this.variantId,
    required this.addedAt,
    required this.name,
    required this.nameAr,
    required this.vendor,
    required this.payable,
    required this.listPrice,
    required this.discount,
    required this.expired,
  });

  factory ApiCartItem.fromJson(Map<String, dynamic> json) {
    return ApiCartItem(
      key: json['key'] ?? '',
      couponId: json['couponId'] ?? '',
      variantId: json['variantId'] ?? '',
      addedAt: json['addedAt'] ?? '',
      name: json['name'] ?? '',
      nameAr: json['nameAr'] ?? '',
      vendor: json['vendor'] ?? '',
      payable: (json['payable'] as num?)?.toDouble() ?? 0.0,
      listPrice: (json['listPrice'] as num?)?.toDouble() ?? 0.0,
      discount: json['discount'] ?? '',
      expired: json['expired'] ?? false,
    );
  }
}

class ApiCartTotals {
  final int itemCount;
  final double subtotal;
  final double totalListPrice;
  final double totalSavings;

  ApiCartTotals({
    required this.itemCount,
    required this.subtotal,
    required this.totalListPrice,
    required this.totalSavings,
  });

  factory ApiCartTotals.fromJson(Map<String, dynamic> json) {
    return ApiCartTotals(
      itemCount: json['itemCount'] ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      totalListPrice: (json['totalListPrice'] as num?)?.toDouble() ?? 0.0,
      totalSavings: (json['totalSavings'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
