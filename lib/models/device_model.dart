import 'package:flutter/material.dart';

enum DeviceCategory {
  lighting,
  cooling,
  entertainment,
  refrigeration,
  laundry,
  heating,
  general,
}

class DeviceModel {
  final String id;
  final String name;
  final DeviceCategory category;
  final String room;
  final double powerRatingWatts; // Rated wattage (e.g., 1450.0 W for AC)
  final double defaultDailyHours; // Typical operating hours per day
  final bool isOn;
  final bool isOnline;
  final String iconName; // Identifies icon for serialization
  final DateTime? lastToggled;

  const DeviceModel({
    required this.id,
    required this.name,
    required this.category,
    required this.room,
    required this.powerRatingWatts,
    required this.defaultDailyHours,
    this.isOn = false,
    this.isOnline = true,
    required this.iconName,
    this.lastToggled,
  });

  /// Active load drawn right now (in Watts). If off, power drawn is 0 (or standby 1W).
  double get currentPowerWatts {
    if (!isOn) return 0.0;
    return powerRatingWatts;
  }

  /// Daily energy consumption in kWh:
  /// Energy (kWh) = Power (Watts) × Operating Hours / 1000
  double get dailyEnergyKWh {
    // If the device is currently off, we model a baseline operating hours fraction
    // If it is turned on, it runs at its full daily hours schedule
    final hours = isOn ? defaultDailyHours : (defaultDailyHours * 0.25);
    return (powerRatingWatts * hours) / 1000.0;
  }

  /// Status string for UI display
  String get statusText {
    if (!isOnline) return 'Offline';
    if (isOn) return 'Running (${currentPowerWatts.toStringAsFixed(0)} W)';
    return 'Turned Off';
  }

  /// Helper to get Material IconData from stored icon name
  IconData get iconData {
    switch (iconName) {
      case 'light':
        return Icons.lightbulb_outline;
      case 'fan':
        return Icons.mode_fan_off_outlined; // will use spinning fan icon in UI
      case 'ac':
        return Icons.ac_unit_rounded;
      case 'tv':
        return Icons.tv_rounded;
      case 'fridge':
        return Icons.kitchen_rounded;
      case 'washing_machine':
        return Icons.local_laundry_service_rounded;
      case 'heater':
        return Icons.shower_rounded; // water geyser / heater
      default:
        return Icons.power_rounded;
    }
  }

  DeviceModel copyWith({
    String? id,
    String? name,
    DeviceCategory? category,
    String? room,
    double? powerRatingWatts,
    double? defaultDailyHours,
    bool? isOn,
    bool? isOnline,
    String? iconName,
    DateTime? lastToggled,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      room: room ?? this.room,
      powerRatingWatts: powerRatingWatts ?? this.powerRatingWatts,
      defaultDailyHours: defaultDailyHours ?? this.defaultDailyHours,
      isOn: isOn ?? this.isOn,
      isOnline: isOnline ?? this.isOnline,
      iconName: iconName ?? this.iconName,
      lastToggled: lastToggled ?? this.lastToggled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.name,
      'room': room,
      'powerRatingWatts': powerRatingWatts,
      'defaultDailyHours': defaultDailyHours,
      'isOn': isOn,
      'isOnline': isOnline,
      'iconName': iconName,
      'lastToggled': lastToggled?.toIso8601String(),
    };
  }

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: DeviceCategory.values.firstWhere(
        (c) => c.name == (json['category'] as String?),
        orElse: () => DeviceCategory.general,
      ),
      room: json['room'] as String? ?? 'Living Room',
      powerRatingWatts: (json['powerRatingWatts'] as num?)?.toDouble() ?? 100.0,
      defaultDailyHours: (json['defaultDailyHours'] as num?)?.toDouble() ?? 4.0,
      isOn: json['isOn'] as bool? ?? false,
      isOnline: json['isOnline'] as bool? ?? true,
      iconName: json['iconName'] as String? ?? 'power',
      lastToggled: json['lastToggled'] != null
          ? DateTime.tryParse(json['lastToggled'] as String)
          : null,
    );
  }

  /// Default predefined smart-home appliances specified in requirements:
  /// Lights, Fans, Air Conditioner, Television, Refrigerator, Washing Machine, Water Heater
  static List<DeviceModel> get defaultDevices {
    return [
      const DeviceModel(
        id: 'dev_lights_01',
        name: 'Living Room Lights',
        category: DeviceCategory.lighting,
        room: 'Living Room',
        powerRatingWatts: 45.0, // 45 Watts LED array
        defaultDailyHours: 6.0,
        isOn: true,
        iconName: 'light',
      ),
      const DeviceModel(
        id: 'dev_fans_02',
        name: 'Ceiling BLDC Fan',
        category: DeviceCategory.cooling,
        room: 'Master Bedroom',
        powerRatingWatts: 35.0, // Energy-efficient BLDC fan
        defaultDailyHours: 9.0,
        isOn: true,
        iconName: 'fan',
      ),
      const DeviceModel(
        id: 'dev_ac_03',
        name: 'Air Conditioner 1.5T',
        category: DeviceCategory.cooling,
        room: 'Master Bedroom',
        powerRatingWatts: 1450.0, // Inverter 5-star AC
        defaultDailyHours: 6.5,
        isOn: false,
        iconName: 'ac',
      ),
      const DeviceModel(
        id: 'dev_tv_04',
        name: 'Television 4K OLED',
        category: DeviceCategory.entertainment,
        room: 'Living Room',
        powerRatingWatts: 120.0,
        defaultDailyHours: 4.0,
        isOn: true,
        iconName: 'tv',
      ),
      const DeviceModel(
        id: 'dev_fridge_05',
        name: 'Refrigerator 340L',
        category: DeviceCategory.refrigeration,
        room: 'Kitchen',
        powerRatingWatts: 180.0, // Compressor cycling (avg ~180W)
        defaultDailyHours: 24.0,
        isOn: true, // Always running in household
        iconName: 'fridge',
      ),
      const DeviceModel(
        id: 'dev_washer_06',
        name: 'Washing Machine 8kg',
        category: DeviceCategory.laundry,
        room: 'Utility Area',
        powerRatingWatts: 500.0,
        defaultDailyHours: 1.5,
        isOn: false,
        iconName: 'washing_machine',
      ),
      const DeviceModel(
        id: 'dev_heater_07',
        name: 'Water Heater Geyser',
        category: DeviceCategory.heating,
        room: 'Bathroom',
        powerRatingWatts: 2000.0, // Instant / Storage geyser
        defaultDailyHours: 1.0,
        isOn: false,
        iconName: 'heater',
      ),
    ];
  }
}
