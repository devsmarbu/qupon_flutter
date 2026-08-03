// ─────────────────────────────────────────────────────────────────────────────
// Typed settings models per gateway identifier
// ─────────────────────────────────────────────────────────────────────────────

abstract class PaymentGatewaySettings {
  const PaymentGatewaySettings();

  /// Factory — returns the correct typed subclass based on [identifier].
  factory PaymentGatewaySettings.fromJson(
    String identifier,
    Map<String, dynamic> json,
  ) {
    switch (identifier) {
      case 'stripe':
        return StripeSettings.fromJson(json);
      case 'tap':
        return TapSettings.fromJson(json);
      case 'wallet':
        return WalletSettings.fromJson(json);
      case 'skipcash':
        return SkipCashSettings.fromJson(json);
      case 'partner':
        return PartnerSettings();
      default:
        return UnknownSettings(raw: json);
    }
  }
}

// ── Stripe ────────────────────────────────────────────────────────────────────
class StripeSettings extends PaymentGatewaySettings {
  final String publishableKey;
  final String secretKey;
  final String webhookSecret;

  const StripeSettings({
    required this.publishableKey,
    required this.secretKey,
    required this.webhookSecret,
  });

  factory StripeSettings.fromJson(Map<String, dynamic> json) {
    return StripeSettings(
      publishableKey: json['publishableKey'] as String? ?? '',
      secretKey: json['secretKey'] as String? ?? '',
      webhookSecret: json['webhookSecret'] as String? ?? '',
    );
  }
}

// ── Tap Payments ──────────────────────────────────────────────────────────────
class TapSettings extends PaymentGatewaySettings {
  final String merchantId;
  final String secretKey;

  const TapSettings({
    required this.merchantId,
    required this.secretKey,
  });

  factory TapSettings.fromJson(Map<String, dynamic> json) {
    return TapSettings(
      merchantId: json['merchantId'] as String? ?? '',
      secretKey: json['secretKey'] as String? ?? '',
    );
  }
}

// ── Wallet ────────────────────────────────────────────────────────────────────
class WalletSettings extends PaymentGatewaySettings {
  final double minBalance;
  final bool allowPartialPay;

  const WalletSettings({
    required this.minBalance,
    required this.allowPartialPay,
  });

  factory WalletSettings.fromJson(Map<String, dynamic> json) {
    return WalletSettings(
      minBalance: double.tryParse(json['minBalance']?.toString() ?? '0') ?? 0.0,
      allowPartialPay: json['allowPartialPay']?.toString().toLowerCase() == 'true',
    );
  }
}

// ── SkipCash ──────────────────────────────────────────────────────────────────
enum SkipCashMode { sandbox, live }

class SkipCashSettings extends PaymentGatewaySettings {
  final String keyId;
  final String secretKey;
  final String clientId;
  final SkipCashMode mode;

  const SkipCashSettings({
    required this.keyId,
    required this.secretKey,
    required this.clientId,
    required this.mode,
  });

  bool get isSandbox => mode == SkipCashMode.sandbox;

  factory SkipCashSettings.fromJson(Map<String, dynamic> json) {
    return SkipCashSettings(
      keyId: json['keyId'] as String? ?? '',
      secretKey: json['secretKey'] as String? ?? '',
      clientId: json['clientId'] as String? ?? '',
      mode: (json['mode'] as String?)?.toLowerCase() == 'live'
          ? SkipCashMode.live
          : SkipCashMode.sandbox,
    );
  }
}

// ── Partner ───────────────────────────────────────────────────────────────────
class PartnerSettings extends PaymentGatewaySettings {
  const PartnerSettings();
}

// ── Fallback for unknown gateways ─────────────────────────────────────────────
class UnknownSettings extends PaymentGatewaySettings {
  final Map<String, dynamic> raw;

  const UnknownSettings({required this.raw});
}

// ─────────────────────────────────────────────────────────────────────────────
// Main PaymentGateway model
// ─────────────────────────────────────────────────────────────────────────────

class PaymentGateway {
  final String id;
  final String identifier;
  final String name;
  final String description;
  final String status;

  /// Raw settings map — kept for backward-compat / serialisation.
  final Map<String, dynamic> settings;

  /// Typed settings — use this for type-safe access.
  final PaymentGatewaySettings typedSettings;

  const PaymentGateway({
    required this.id,
    required this.identifier,
    required this.name,
    required this.description,
    required this.status,
    required this.settings,
    required this.typedSettings,
  });

  bool get isActive => status == 'active';

  /// Convenience typed accessors (safe casts, null if wrong gateway type)
  StripeSettings? get stripeSettings =>
      typedSettings is StripeSettings ? typedSettings as StripeSettings : null;

  TapSettings? get tapSettings =>
      typedSettings is TapSettings ? typedSettings as TapSettings : null;

  WalletSettings? get walletSettings =>
      typedSettings is WalletSettings ? typedSettings as WalletSettings : null;

  SkipCashSettings? get skipCashSettings =>
      typedSettings is SkipCashSettings ? typedSettings as SkipCashSettings : null;

  PartnerSettings? get partnerSettings =>
      typedSettings is PartnerSettings ? typedSettings as PartnerSettings : null;

  factory PaymentGateway.fromJson(Map<String, dynamic> json) {
    final identifier = json['identifier'] as String? ?? '';
    final rawSettings = (json['settings'] as Map<String, dynamic>?) ?? {};
    return PaymentGateway(
      id: json['id'] as String? ?? '',
      identifier: identifier,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'inactive',
      settings: rawSettings,
      typedSettings: PaymentGatewaySettings.fromJson(identifier, rawSettings),
    );
  }
}
