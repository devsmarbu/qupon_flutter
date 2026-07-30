import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_strings.dart';
import '../../features/account/data/models/profile_data.dart';

class PrefStore {
  // Private constructor
  PrefStore._internal();

  // Singleton instance
  static final PrefStore _instance = PrefStore._internal();

  factory PrefStore() => _instance;

  // SharedPreferences instance
  static SharedPreferences? _prefs;

  /// Initialize once (call in main before runApp)
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Save a string
  Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  /// Load a string
  String? loadString(String key) {
    return _prefs?.getString(key);
  }

  /// Save a Boolean
  Future<void> saveBoolean(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  /// Load a Boolean
  bool? loadBoolean(String key) {
    return _prefs?.getBool(key);
  }

  /// Save an int
  Future<void> saveInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  /// Load an int
  int? loadInt(String key) {
    return _prefs?.getInt(key);
  }

  /// Remove a key
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  /// Clear all preferences
  Future<void> clearAll() async {
    await _prefs?.clear();
  }

  // SAVE model
  static Future<void> saveProfile(ProfileData? profile) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(profile?.toJson());
    await prefs.setString(AppStrings.keyProfile, jsonString);
  }

  // GET model
  static Future<ProfileData?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(AppStrings.keyProfile);

    if (jsonString == null) return null;

    final map = jsonDecode(jsonString);
    return ProfileData.fromJson(map);
  }

  // CLEAR model
  static Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppStrings.keyProfile);
  }
}
