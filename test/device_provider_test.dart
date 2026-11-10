import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home_energy/models/device_model.dart';
import 'package:smart_home_energy/models/energy_model.dart';
import 'package:smart_home_energy/providers/device_provider.dart';
import 'package:smart_home_energy/services/storage_service.dart';

class InMemoryStorageService extends StorageService {
  List<DeviceModel>? storedDevices;
  double storedTariff = 7.50;
  bool storedDark = true;
  bool storedNotifs = true;
  bool storedEco = false;

  @override
  Future<void> init() async {}

  @override
  Future<void> saveDevices(List<DeviceModel> devices) async {
    storedDevices = List.from(devices);
  }

  @override
  Future<List<DeviceModel>?> loadDevices() async {
    return storedDevices != null ? List.from(storedDevices!) : null;
  }

  @override
  Future<void> saveTariffRate(double rate) async {
    storedTariff = rate;
  }

  @override
  Future<double> loadTariffRate() async {
    return storedTariff;
  }

  @override
  Future<void> saveDarkMode(bool isDark) async {
    storedDark = isDark;
  }

  @override
  Future<bool> loadDarkMode() async {
    return storedDark;
  }

  @override
  Future<UserProfile> loadUserProfile() async {
    return UserProfile.defaultProfile;
  }
}

void main() {
  group('DeviceProvider State Management Tests', () {
    late InMemoryStorageService mockStorage;
    late DeviceProvider deviceProvider;

    setUp(() async {
      mockStorage = InMemoryStorageService();
      deviceProvider = DeviceProvider(storageService: mockStorage);
      await deviceProvider.loadDevices();
    });

    test('Initializes with 7 default appliances', () {
      expect(deviceProvider.totalDevicesCount, equals(7));
      expect(deviceProvider.devices.any((d) => d.name.contains('Lights')), isTrue);
      expect(deviceProvider.devices.any((d) => d.name.contains('Fan')), isTrue);
      expect(deviceProvider.devices.any((d) => d.name.contains('Air Conditioner')), isTrue);
      expect(deviceProvider.devices.any((d) => d.name.contains('Television')), isTrue);
      expect(deviceProvider.devices.any((d) => d.name.contains('Refrigerator')), isTrue);
      expect(deviceProvider.devices.any((d) => d.name.contains('Washing Machine')), isTrue);
      expect(deviceProvider.devices.any((d) => d.name.contains('Water Heater')), isTrue);
    });

    test('Toggling device ON adds its power to active load', () async {
      final ac = deviceProvider.devices.firstWhere((d) => d.iconName == 'ac');
      expect(ac.isOn, isFalse);

      final initialActiveLoad = deviceProvider.totalActiveLoadWatts;
      final initialActiveCount = deviceProvider.activeDevicesCount;

      // Turn AC ON
      await deviceProvider.toggleDevice(ac.id);

      final updatedAc = deviceProvider.devices.firstWhere((d) => d.id == ac.id);
      expect(updatedAc.isOn, isTrue);
      expect(deviceProvider.activeDevicesCount, equals(initialActiveCount + 1));
      expect(
        deviceProvider.totalActiveLoadWatts,
        equals(initialActiveLoad + ac.powerRatingWatts),
      );
    });

    test('Toggling device OFF removes its power from active load', () async {
      final light = deviceProvider.devices.firstWhere((d) => d.iconName == 'light');
      expect(light.isOn, isTrue);

      final initialActiveLoad = deviceProvider.totalActiveLoadWatts;

      // Turn Light OFF
      await deviceProvider.toggleDevice(light.id);

      final updatedLight = deviceProvider.devices.firstWhere((d) => d.id == light.id);
      expect(updatedLight.isOn, isFalse);
      expect(
        deviceProvider.totalActiveLoadWatts,
        equals(initialActiveLoad - light.powerRatingWatts),
      );
    });

    test('turnAllOff sets active devices count to 0 and active load to 0', () async {
      await deviceProvider.turnAllOff();

      expect(deviceProvider.activeDevicesCount, equals(0));
      expect(deviceProvider.totalActiveLoadWatts, equals(0.0));
      for (final d in deviceProvider.devices) {
        expect(d.isOn, isFalse);
      }
    });

    test('turnAllOn turns on all 7 appliances', () async {
      await deviceProvider.turnAllOn();

      expect(deviceProvider.activeDevicesCount, equals(7));
      for (final d in deviceProvider.devices) {
        expect(d.isOn, isTrue);
      }
      expect(deviceProvider.totalActiveLoadWatts, greaterThan(4000.0));
    });

    test('turnOffHeavyLoads turns off appliances with power rating >= 1000W', () async {
      await deviceProvider.turnAllOn();

      await deviceProvider.turnOffHeavyLoads();

      final ac = deviceProvider.devices.firstWhere((d) => d.iconName == 'ac');
      final heater = deviceProvider.devices.firstWhere((d) => d.iconName == 'heater');
      final fan = deviceProvider.devices.firstWhere((d) => d.iconName == 'fan');

      expect(ac.isOn, isFalse); // 1450W
      expect(heater.isOn, isFalse); // 2000W
      expect(fan.isOn, isTrue); // 35W remains ON
    });
  });
}
