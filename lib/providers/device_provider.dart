import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../services/energy_calculation_service.dart';
import '../services/storage_service.dart';

class DeviceProvider extends ChangeNotifier {
  final StorageService _storageService;

  List<DeviceModel> _devices = [];
  bool _isLoading = true;
  String? _errorMessage;

  DeviceProvider({required StorageService storageService})
      : _storageService = storageService;

  // Getters
  List<DeviceModel> get devices => List.unmodifiable(_devices);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get totalDevicesCount => _devices.length;

  int get activeDevicesCount => _devices.where((d) => d.isOn).length;

  /// Real-time sum of power consumption in Watts for all active appliances
  double get totalActiveLoadWatts {
    return EnergyCalculationService.calculateTotalActiveLoadWatts(_devices);
  }

  /// Total calculated daily energy consumption in kWh
  double get totalDailyEnergyKWh {
    return EnergyCalculationService.calculateTotalDailyKWh(_devices);
  }

  /// Finds the appliance consuming the most electricity (in daily kWh)
  DeviceModel? get highestConsumingDevice {
    if (_devices.isEmpty) return null;
    DeviceModel highest = _devices.first;
    for (final dev in _devices) {
      if (dev.dailyEnergyKWh > highest.dailyEnergyKWh) {
        highest = dev;
      }
    }
    return highest;
  }

  /// Unique list of rooms available in the home
  List<String> get availableRooms {
    final set = _devices.map((d) => d.room).toSet();
    return ['All', ...set];
  }

  /// Load devices from SharedPreferences or initialize default appliances
  Future<void> loadDevices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final saved = await _storageService.loadDevices();
      if (saved != null && saved.isNotEmpty) {
        _devices = saved;
      } else {
        _devices = DeviceModel.defaultDevices;
        await _storageService.saveDevices(_devices);
      }
    } catch (e) {
      _errorMessage = 'Failed to load device states: $e';
      _devices = DeviceModel.defaultDevices;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggles appliance ON or OFF and immediately updates state and storage
  Future<void> toggleDevice(String id) async {
    final index = _devices.indexWhere((d) => d.id == id);
    if (index == -1) return;

    final target = _devices[index];
    final updated = target.copyWith(
      isOn: !target.isOn,
      lastToggled: DateTime.now(),
    );

    _devices[index] = updated;
    notifyListeners(); // Immediate state update per requirements

    // Persist to SharedPreferences
    await _storageService.saveDevices(_devices);
  }

  /// Turn all devices ON
  Future<void> turnAllOn() async {
    _devices = _devices.map((d) => d.copyWith(isOn: true, lastToggled: DateTime.now())).toList();
    notifyListeners();
    await _storageService.saveDevices(_devices);
  }

  /// Turn all devices OFF (immediate standby/zero load)
  Future<void> turnAllOff() async {
    _devices = _devices.map((d) => d.copyWith(isOn: false, lastToggled: DateTime.now())).toList();
    notifyListeners();
    await _storageService.saveDevices(_devices);
  }

  /// Turn off high-load devices for energy conservation
  Future<void> turnOffHeavyLoads() async {
    _devices = _devices.map((d) {
      if (d.powerRatingWatts >= 1000.0) {
        return d.copyWith(isOn: false, lastToggled: DateTime.now());
      }
      return d;
    }).toList();
    notifyListeners();
    await _storageService.saveDevices(_devices);
  }

  /// Update operating hours for a specific appliance
  Future<void> updateDeviceHours(String id, double newHours) async {
    final index = _devices.indexWhere((d) => d.id == id);
    if (index == -1) return;

    final target = _devices[index];
    _devices[index] = target.copyWith(defaultDailyHours: newHours);
    notifyListeners();
    await _storageService.saveDevices(_devices);
  }

  /// Reset all devices back to default demo configuration
  Future<void> resetToDefaults() async {
    _devices = DeviceModel.defaultDevices;
    notifyListeners();
    await _storageService.saveDevices(_devices);
  }

  /// Helper to get devices by room
  List<DeviceModel> getDevicesForRoom(String room) {
    if (room == 'All') return _devices;
    return _devices.where((d) => d.room == room).toList();
  }
}
