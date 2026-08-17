import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../../core/preferences/pref_store.dart';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  Map<String, String> _enLabels = {};
  Map<String, String> _arLabels = {};
  String _currentLang = 'en';

  static const String _keyEn = 'storefront_labels_en';
  static const String _keyAr = 'storefront_labels_ar';

  void setLanguage(String lang) {
    _currentLang = lang;
  }

  String get currentLanguage => _currentLang;

  void updateLabels({required Map<String, String> en, required Map<String, String> ar}) {
    _enLabels = en;
    _arLabels = ar;
    debugPrint('[LocalizationService] updateLabels: EN=${en.length} keys, AR=${ar.length} keys');
    
    // Save to pref store
    PrefStore().saveString(_keyEn, jsonEncode(en));
    PrefStore().saveString(_keyAr, jsonEncode(ar));
  }

  void init() {
    try {
      final enJson = PrefStore().loadString(_keyEn);
      final arJson = PrefStore().loadString(_keyAr);
      if (enJson != null && enJson.isNotEmpty) {
        _enLabels = Map<String, String>.from(jsonDecode(enJson));
      }
      if (arJson != null && arJson.isNotEmpty) {
        _arLabels = Map<String, String>.from(jsonDecode(arJson));
      }
      debugPrint('[LocalizationService] init: loaded EN=${_enLabels.length}, AR=${_arLabels.length} from cache');
    } catch (e) {
      debugPrint('[LocalizationService] init error: $e');
    }
  }

  String getString(String key, String defaultValue) {
    final map = _currentLang == 'ar' ? _arLabels : _enLabels;
    return map[key] ?? defaultValue;
  }
}
