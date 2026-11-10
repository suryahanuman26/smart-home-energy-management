import 'package:flutter/material.dart';
import '../models/energy_model.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService;

  double _tariffRate = AppConstants.defaultTariffRate;
  bool _isDarkMode = true;
  bool _notificationsEnabled = true;
  bool _ecoModeEnabled = false;
  double _monthlyBudget = AppConstants.defaultMonthlyBudget;
  UserProfile _userProfile = UserProfile.defaultProfile;
  bool _isLoading = true;

  SettingsProvider({required StorageService storageService})
      : _storageService = storageService;

  // Getters
  double get tariffRate => _tariffRate;
  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get ecoModeEnabled => _ecoModeEnabled;
  double get monthlyBudget => _monthlyBudget;
  UserProfile get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  /// Initialize and load saved settings from SharedPreferences
  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    _tariffRate = await _storageService.loadTariffRate();
    _isDarkMode = await _storageService.loadDarkMode();
    _notificationsEnabled = await _storageService.loadNotifications();
    _ecoModeEnabled = await _storageService.loadEcoMode();
    _monthlyBudget = await _storageService.loadMonthlyBudget();
    _userProfile = await _storageService.loadUserProfile();

    _isLoading = false;
    notifyListeners();
  }

  /// Update tariff rate (in ₹ per kWh)
  Future<void> setTariffRate(double rate) async {
    if (rate <= 0) return;
    _tariffRate = double.parse(rate.toStringAsFixed(2));
    await _storageService.saveTariffRate(_tariffRate);
    notifyListeners();
  }

  /// Toggle dark / light theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storageService.saveDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> setDarkMode(bool isDark) async {
    _isDarkMode = isDark;
    await _storageService.saveDarkMode(_isDarkMode);
    notifyListeners();
  }

  /// Toggle notification alerts
  Future<void> setNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    await _storageService.saveNotifications(_notificationsEnabled);
    notifyListeners();
  }

  /// Toggle eco mode (intelligent power-saving recommendations)
  Future<void> setEcoMode(bool enabled) async {
    _ecoModeEnabled = enabled;
    await _storageService.saveEcoMode(_ecoModeEnabled);
    notifyListeners();
  }

  /// Set monthly target budget in ₹
  Future<void> setMonthlyBudget(double budget) async {
    _monthlyBudget = budget;
    await _storageService.saveMonthlyBudget(_monthlyBudget);
    notifyListeners();
  }

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? email,
    String? homeName,
    String? meterId,
  }) async {
    _userProfile = UserProfile(
      name: name ?? _userProfile.name,
      email: email ?? _userProfile.email,
      homeName: homeName ?? _userProfile.homeName,
      meterId: meterId ?? _userProfile.meterId,
    );
    await _storageService.saveUserProfile(_userProfile);
    notifyListeners();
  }

  /// Reset all settings to demo defaults
  Future<void> resetToDefaults() async {
    _tariffRate = AppConstants.defaultTariffRate;
    _isDarkMode = true;
    _notificationsEnabled = true;
    _ecoModeEnabled = false;
    _monthlyBudget = AppConstants.defaultMonthlyBudget;
    _userProfile = UserProfile.defaultProfile;

    await _storageService.saveTariffRate(_tariffRate);
    await _storageService.saveDarkMode(_isDarkMode);
    await _storageService.saveNotifications(_notificationsEnabled);
    await _storageService.saveEcoMode(_ecoModeEnabled);
    await _storageService.saveMonthlyBudget(_monthlyBudget);
    await _storageService.saveUserProfile(_userProfile);

    notifyListeners();
  }
}
