import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home_energy/models/device_model.dart';
import 'package:smart_home_energy/models/energy_model.dart';
import 'package:smart_home_energy/providers/settings_provider.dart';
import 'package:smart_home_energy/services/storage_service.dart';
import 'package:smart_home_energy/utils/constants.dart';

class MockStorageService extends StorageService {
  double tariff = AppConstants.defaultTariffRate;
  bool isDark = true;
  bool notifs = true;
  bool eco = false;
  double budget = AppConstants.defaultMonthlyBudget;
  UserProfile profile = UserProfile.defaultProfile;

  @override
  Future<void> init() async {}

  @override
  Future<void> saveTariffRate(double rate) async => tariff = rate;
  @override
  Future<double> loadTariffRate() async => tariff;

  @override
  Future<void> saveDarkMode(bool val) async => isDark = val;
  @override
  Future<bool> loadDarkMode() async => isDark;

  @override
  Future<void> saveNotifications(bool val) async => notifs = val;
  @override
  Future<bool> loadNotifications() async => notifs;

  @override
  Future<void> saveEcoMode(bool val) async => eco = val;
  @override
  Future<bool> loadEcoMode() async => eco;

  @override
  Future<void> saveMonthlyBudget(double val) async => budget = val;
  @override
  Future<double> loadMonthlyBudget() async => budget;

  @override
  Future<void> saveUserProfile(UserProfile p) async => profile = p;
  @override
  Future<UserProfile> loadUserProfile() async => profile;

  @override
  Future<void> saveDevices(List<DeviceModel> devices) async {}
  @override
  Future<List<DeviceModel>?> loadDevices() async => null;
}

void main() {
  group('SettingsProvider Unit Tests', () {
    late MockStorageService mockStorage;
    late SettingsProvider settingsProvider;

    setUp(() async {
      mockStorage = MockStorageService();
      settingsProvider = SettingsProvider(storageService: mockStorage);
      await settingsProvider.loadSettings();
    });

    test('Initializes with default tariff ₹7.50 and dark mode true', () {
      expect(settingsProvider.tariffRate, equals(7.50));
      expect(settingsProvider.isDarkMode, isTrue);
      expect(settingsProvider.notificationsEnabled, isTrue);
    });

    test('setTariffRate updates tariff and calls notifyListeners', () async {
      bool notified = false;
      settingsProvider.addListener(() => notified = true);

      await settingsProvider.setTariffRate(9.25);

      expect(settingsProvider.tariffRate, equals(9.25));
      expect(mockStorage.tariff, equals(9.25));
      expect(notified, isTrue);
    });

    test('toggleTheme toggles isDarkMode between true and false', () async {
      expect(settingsProvider.isDarkMode, isTrue);

      await settingsProvider.toggleTheme();
      expect(settingsProvider.isDarkMode, isFalse);
      expect(mockStorage.isDark, isFalse);

      await settingsProvider.toggleTheme();
      expect(settingsProvider.isDarkMode, isTrue);
      expect(mockStorage.isDark, isTrue);
    });

    test('resetToDefaults restores initial baseline values', () async {
      await settingsProvider.setTariffRate(12.0);
      await settingsProvider.setDarkMode(false);
      await settingsProvider.setEcoMode(true);

      await settingsProvider.resetToDefaults();

      expect(settingsProvider.tariffRate, equals(AppConstants.defaultTariffRate));
      expect(settingsProvider.isDarkMode, isTrue);
      expect(settingsProvider.ecoModeEnabled, isFalse);
    });
  });
}
