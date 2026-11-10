import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/device_model.dart';
import '../models/energy_model.dart';
import '../utils/constants.dart';

class StorageService {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // --- Devices Persistence ---
  Future<void> saveDevices(List<DeviceModel> devices) async {
    await init();
    final jsonList = devices.map((d) => d.toJson()).toList();
    final rawString = jsonEncode(jsonList);
    await _prefs?.setString(AppConstants.keyDevices, rawString);
  }

  Future<List<DeviceModel>?> loadDevices() async {
    await init();
    final rawString = _prefs?.getString(AppConstants.keyDevices);
    if (rawString == null || rawString.isEmpty) return null;

    try {
      final List<dynamic> decoded = jsonDecode(rawString) as List<dynamic>;
      return decoded.map((item) => DeviceModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      // If parsing fails, fall back to null so default devices load
      return null;
    }
  }

  // --- Tariff Rate Persistence ---
  Future<void> saveTariffRate(double rate) async {
    await init();
    await _prefs?.setDouble(AppConstants.keyTariffRate, rate);
  }

  Future<double> loadTariffRate() async {
    await init();
    return _prefs?.getDouble(AppConstants.keyTariffRate) ?? AppConstants.defaultTariffRate;
  }

  // --- Theme Mode Persistence ---
  Future<void> saveDarkMode(bool isDark) async {
    await init();
    await _prefs?.setBool(AppConstants.keyIsDarkMode, isDark);
  }

  Future<bool> loadDarkMode() async {
    await init();
    return _prefs?.getBool(AppConstants.keyIsDarkMode) ?? true; // Default dark navy
  }

  // --- Notifications Persistence ---
  Future<void> saveNotifications(bool enabled) async {
    await init();
    await _prefs?.setBool(AppConstants.keyNotifications, enabled);
  }

  Future<bool> loadNotifications() async {
    await init();
    return _prefs?.getBool(AppConstants.keyNotifications) ?? true;
  }

  // --- Eco Mode Persistence ---
  Future<void> saveEcoMode(bool enabled) async {
    await init();
    await _prefs?.setBool(AppConstants.keyEcoMode, enabled);
  }

  Future<bool> loadEcoMode() async {
    await init();
    return _prefs?.getBool(AppConstants.keyEcoMode) ?? false;
  }

  // --- User Profile Persistence ---
  Future<void> saveUserProfile(UserProfile profile) async {
    await init();
    await _prefs?.setString(AppConstants.keyUserProfile, jsonEncode(profile.toJson()));
  }

  Future<UserProfile> loadUserProfile() async {
    await init();
    final raw = _prefs?.getString(AppConstants.keyUserProfile);
    if (raw == null) return UserProfile.defaultProfile;
    try {
      return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return UserProfile.defaultProfile;
    }
  }

  // --- Monthly Budget Persistence ---
  Future<void> saveMonthlyBudget(double budget) async {
    await init();
    await _prefs?.setDouble(AppConstants.keyMonthlyBudget, budget);
  }

  Future<double> loadMonthlyBudget() async {
    await init();
    return _prefs?.getDouble(AppConstants.keyMonthlyBudget) ?? AppConstants.defaultMonthlyBudget;
  }

  // --- Reset All Stored Demo Data ---
  Future<void> resetAll() async {
    await init();
    await _prefs?.clear();
  }
}
