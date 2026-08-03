class DashboardTransaction {
  final String id;
  final String title;
  final String date;
  final String price; // Formatted price, e.g., "-QAR 85" or "+QAR 25"
  final String type; // e.g., 'grocery', 'redeemed', 'coffee', or 'other'

  DashboardTransaction({
    required this.id,
    required this.title,
    required this.date,
    required this.price,
    required this.type,
  });

  factory DashboardTransaction.fromJson(Map<String, dynamic> json) {
    String rawPrice = json['price']?.toString() ?? '';
    if (rawPrice.isEmpty) {
      final amount = json['amount'] ?? 0.0;
      final isCredit = json['isCredit'] ?? (json['type'] == 'redeemed' || json['type'] == 'credit');
      rawPrice = '${isCredit ? '+' : '-'}QAR $amount';
    }
    return DashboardTransaction(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      date: json['date']?.toString() ?? json['createdAt']?.toString() ?? json['addedAt']?.toString() ?? '',
      price: rawPrice,
      type: json['type']?.toString() ?? 'other',
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

    final rawTransactions = data['transactions'] as List<dynamic>? ?? [];
    final transactions = rawTransactions
        .whereType<Map<String, dynamic>>()
        .map((t) => DashboardTransaction.fromJson(t))
        .toList();

    return DashboardData(
      totalSpent: (data['totalSpent'] as num?)?.toDouble() ?? 0.0,
      couponsUsed: (data['couponsUsed'] as num?)?.toInt() ?? 0,
      totalSaved: (data['totalSaved'] as num?)?.toDouble() ?? 0.0,
      activeCoupons: (data['activeCoupons'] as num?)?.toInt() ?? 0,
      wallet: (data['wallet'] as num?)?.toDouble() ?? 0.0,
      transactions: transactions,
    );
  }
}
