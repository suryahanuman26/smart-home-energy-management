import 'package:flutter/material.dart';
import '../utils/constants.dart';

class HourlyConsumption {
  final int hour; // 0 to 23
  final double kwh;
  final double loadWatts;

  const HourlyConsumption({
    required this.hour,
    required this.kwh,
    required this.loadWatts,
  });

  String get label => '${hour.toString().padLeft(2, '0')}:00';
}

class DailyConsumption {
  final String day; // Mon, Tue, etc.
  final DateTime date;
  final double kwh;
  final double cost;

  const DailyConsumption({
    required this.day,
    required this.date,
    required this.kwh,
    required this.cost,
  });
}

class WeeklyConsumption {
  final String weekLabel; // Week 1, Week 2, etc.
  final double kwh;
  final double cost;

  const WeeklyConsumption({
    required this.weekLabel,
    required this.kwh,
    required this.cost,
  });
}

class MonthlyConsumption {
  final String monthLabel; // Jan, Feb, etc.
  final double kwh;
  final double cost;

  const MonthlyConsumption({
    required this.monthLabel,
    required this.kwh,
    required this.cost,
  });
}

enum InsightSeverity { info, warning, alert, success }

class EnergyInsight {
  final String id;
  final String title;
  final String description;
  final String actionLabel;
  final InsightSeverity severity;
  final IconData icon;
  final double potentialSavingsRupees;
  final double potentialSavingsKWh;

  const EnergyInsight({
    required this.id,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.severity,
    required this.icon,
    this.potentialSavingsRupees = 0.0,
    this.potentialSavingsKWh = 0.0,
  });

  Color get accentColor {
    switch (severity) {
      case InsightSeverity.alert:
        return AppColors.alertDanger;
      case InsightSeverity.warning:
        return AppColors.alertWarning;
      case InsightSeverity.success:
        return AppColors.alertSuccess;
      case InsightSeverity.info:
      default:
        return AppColors.energyTeal;
    }
  }
}

class UserProfile {
  final String name;
  final String email;
  final String homeName;
  final String meterId;

  const UserProfile({
    required this.name,
    required this.email,
    required this.homeName,
    required this.meterId,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'homeName': homeName,
        'meterId': meterId,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String? ?? 'Surya Sharma',
        email: json['email'] as String? ?? 'surya.sharma@smarthome.io',
        homeName: json['homeName'] as String? ?? 'Green Villa - Unit 402',
        meterId: json['meterId'] as String? ?? 'SMART-IND-78921',
      );

  static const defaultProfile = UserProfile(
    name: 'Surya Sharma',
    email: 'surya.sharma@smarthome.io',
    homeName: 'Green Villa - Unit 402',
    meterId: 'SMART-IND-78921',
  );
}

class SDGGoalItem {
  final int number;
  final String title;
  final String subtitle;
  final String description;
  final String practicalTip;
  final Color color;
  final IconData icon;

  const SDGGoalItem({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.practicalTip,
    required this.color,
    required this.icon,
  });

  static List<SDGGoalItem> get allGoals => [
        const SDGGoalItem(
          number: 7,
          title: 'Affordable and Clean Energy',
          subtitle: 'Ensure access to affordable, reliable, sustainable modern energy for all',
          description:
              'Smart meters and real-time load analytics reduce peak power demand on municipal grids, enabling greater penetration of renewable solar and wind power without overloading infrastructure.',
          practicalTip:
              'Schedule high-load appliances like washing machines and geysers during daytime peak solar production hours (10:00 AM - 2:00 PM).',
          color: AppColors.sdg7Yellow,
          icon: Icons.solar_power_rounded,
        ),
        const SDGGoalItem(
          number: 12,
          title: 'Responsible Consumption & Production',
          subtitle: 'Ensure sustainable consumption and production patterns',
          description:
              'Eliminating standby phantom loads and unmanaged idle equipment directly reduces household electricity waste by 15% to 25% each billing cycle.',
          practicalTip:
              'Turn off air conditioning 30 minutes before waking up or leaving the room; thermal inertia keeps the room cool.',
          color: AppColors.sdg12Orange,
          icon: Icons.recycling_rounded,
        ),
        const SDGGoalItem(
          number: 13,
          title: 'Climate Action',
          subtitle: 'Take urgent action to combat climate change and its impacts',
          description:
              'For every 1 kWh of electricity conserved in India, approximately 0.82 kg of CO2 carbon emissions are avoided at thermal power stations.',
          practicalTip:
              'Maintaining your AC at 24°C instead of 18°C saves up to 24% electricity and prevents over 120 kg of carbon emissions monthly.',
          color: AppColors.sdg13Green,
          icon: Icons.eco_rounded,
        ),
      ];
}
