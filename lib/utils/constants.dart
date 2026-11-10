import 'package:flutter/material.dart';

/// Application constants for Smart Home Energy Management System
class AppConstants {
  // Application Info
  static const String appName = 'Smart Energy';
  static const String appTagline = 'Manage Energy, Build a Greener Future';
  static const String appVersion = '1.0.0';
  static const String currencySymbol = '₹';

  // Demo disclaimer per functional requirements
  static const String demoDisclaimer =
      'Simulated Demo Mode: Power and energy values are dynamically calculated '
      'using typical appliance wattage ratings and standard operating hours. '
      'This application does not claim physical IoT smart meter hardware integration.';

  // Storage Keys for SharedPreferences
  static const String keyDevices = 'smart_energy_devices_v1';
  static const String keyTariffRate = 'smart_energy_tariff_rate';
  static const String keyIsDarkMode = 'smart_energy_is_dark_mode';
  static const String keyNotifications = 'smart_energy_notifications';
  static const String keyEcoMode = 'smart_energy_eco_mode';
  static const String keyUserProfile = 'smart_energy_user_profile';
  static const String keyMonthlyBudget = 'smart_energy_monthly_budget';

  // Defaults
  static const double defaultTariffRate = 7.50; // ₹ per kWh
  static const double defaultMonthlyBudget = 3000.0; // ₹
  static const double co2EmissionFactor = 0.82; // kg CO2 per kWh (Grid average)
  static const double treeAbsorptionPerYearKg = 21.77; // kg CO2 absorbed per tree/year
}

/// Palette constants adhering to the design requirements:
/// "Dark navy, white, and electric green color palette"
class AppColors {
  // Dark Navy palette
  static const Color darkNavyBackground = Color(0xFF090E17);
  static const Color darkNavySurface = Color(0xFF10192A);
  static const Color darkNavyCard = Color(0xFF162238);
  static const Color darkNavyCardElevated = Color(0xFF1E2D4A);
  static const Color darkNavyBorder = Color(0xFF273859);

  // Light Palette
  static const Color lightBackground = Color(0xFFF4F7FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardElevated = Color(0xFFF8FAFC);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Electric Green & Energy Accents
  static const Color electricGreen = Color(0xFF00E676);
  static const Color electricGreenAccent = Color(0xFF00FFA3);
  static const Color electricGreenGlow = Color(0x3300E676);
  static const Color energyTeal = Color(0xFF00E5FF);
  static const Color energyCyan = Color(0xFF06B6D4);

  // Status & Utility Colors
  static const Color alertWarning = Color(0xFFF59E0B);
  static const Color alertDanger = Color(0xFFEF4444);
  static const Color alertSuccess = Color(0xFF10B981);
  static const Color alertInfo = Color(0xFF3B82F6);

  // Text Colors (Dark Theme)
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);

  // Text Colors (Light Theme)
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textTertiaryLight = Color(0xFF94A3B8);

  // SDG Brand Colors
  static const Color sdg7Yellow = Color(0xFFFCC30B); // Affordable & Clean Energy
  static const Color sdg12Orange = Color(0xFFCF8D2A); // Responsible Consumption
  static const Color sdg13Green = Color(0xFF48773E); // Climate Action
}
