import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_strings.dart';

/// Thin persistence layer for the cart's local item list.
///
/// Uses [SharedPreferences] (already initialised in `main()` via [PrefStore.init])
/// to serialise/deserialise `List<Map<String, String>>` as a JSON string.
class CartLocalStorage {
  CartLocalStorage._(); // utility class — no instances

  static SharedPreferences? _prefs;

  /// Returns the [SharedPreferences] instance, initialising it lazily if needed.
  static Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Persist [items] to local storage.
  static Future<void> saveItems(List<Map<String, String>> items) async {
    final prefs = await _getPrefs();
    // Encode as a JSON array of objects, e.g. [{"couponId":"…","variantId":"…","addedAt":"…"}]
    final encoded = jsonEncode(items);
    await prefs.setString(AppStrings.keyCartItems, encoded);
  }

  /// Load persisted items synchronously.
  ///
  /// Returns an empty list if nothing has been saved yet.
  /// Must be called after [SharedPreferences.getInstance()] has already resolved
  /// (guaranteed because [PrefStore.init] is awaited before [runApp]).
  static List<Map<String, String>> loadItems(SharedPreferences prefs) {
    final raw = prefs.getString(AppStrings.keyCartItems);
    if (raw == null || raw.isEmpty) return const [];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => Map<String, String>.from(e as Map))
          .toList();
    } catch (_) {
      // Corrupted data — start fresh.
      return const [];
    }
  }

  /// Remove the persisted cart (call on checkout success or explicit clear).
  static Future<void> clear() async {
    final prefs = await _getPrefs();
    await prefs.remove(AppStrings.keyCartItems);
    await prefs.remove(AppStrings.keyCartCount);
  }

  // ── Item-count helpers ────────────────────────────────────────────────────

  /// Persist the cart item count for instant badge display on restart.
  static Future<void> saveCount(int count) async {
    final prefs = await _getPrefs();
    await prefs.setInt(AppStrings.keyCartCount, count);
  }

  /// Load the persisted cart item count synchronously.
  ///
  /// Returns 0 if nothing has been saved yet.
  static int loadCount(SharedPreferences prefs) {
    return prefs.getInt(AppStrings.keyCartCount) ?? 0;
  }
}
