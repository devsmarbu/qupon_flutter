class AccountDeletionStatus {
  final bool deletionRequested;
  final DateTime? deletionRequestedAt;
  final String? deletionReason;

  const AccountDeletionStatus({
    this.deletionRequested = false,
    this.deletionRequestedAt,
    this.deletionReason,
  });

  factory AccountDeletionStatus.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    final dateStr = json['deletionRequestedAt']?.toString();
    if (dateStr != null && dateStr.isNotEmpty) {
      parsedDate = DateTime.tryParse(dateStr);
    }

    return AccountDeletionStatus(
      deletionRequested: json['deletionRequested'] == true,
      deletionRequestedAt: parsedDate,
      deletionReason: json['deletionReason']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deletionRequested': deletionRequested,
      'deletionRequestedAt': deletionRequestedAt?.toIso8601String(),
      'deletionReason': deletionReason,
    };
  }

  AccountDeletionStatus copyWith({
    bool? deletionRequested,
    DateTime? deletionRequestedAt,
    String? deletionReason,
  }) {
    return AccountDeletionStatus(
      deletionRequested: deletionRequested ?? this.deletionRequested,
      deletionRequestedAt: deletionRequestedAt ?? this.deletionRequestedAt,
      deletionReason: deletionReason ?? this.deletionReason,
    );
  }
}
