import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../models/energy_model.dart';
import '../services/energy_calculation_service.dart';
import 'device_provider.dart';
import 'settings_provider.dart';

class EnergyProvider extends ChangeNotifier {
  DeviceProvider? _deviceProvider;
  SettingsProvider? _settingsProvider;

  // Cached analytical datasets
  List<HourlyConsumption> _hourlyCurve = [];
  List<DailyConsumption> _past7Days = [];
  List<WeeklyConsumption> _past4Weeks = [];
  List<MonthlyConsumption> _past6Months = [];

  void update(DeviceProvider deviceProvider, SettingsProvider settingsProvider) {
    _deviceProvider = deviceProvider;
    _settingsProvider = settingsProvider;
    _refreshAnalytics();
    notifyListeners();
  }

  void _refreshAnalytics() {
    final activeWatts = _deviceProvider?.totalActiveLoadWatts ?? 0.0;
    final dailyKWh = _deviceProvider?.totalDailyEnergyKWh ?? 14.5;
    final tariff = _settingsProvider?.tariffRate ?? 7.50;

    _hourlyCurve = EnergyCalculationService.generateHourlyLoadCurve(activeWatts);
    _past7Days = EnergyCalculationService.generatePast7DaysHistory(dailyKWh, tariff);
    _past4Weeks = EnergyCalculationService.generatePast4WeeksHistory(dailyKWh, tariff);
    _past6Months = EnergyCalculationService.generatePast6MonthsHistory(dailyKWh, tariff);
  }

  // --- Dynamic Dashboard & Metrics Getters ---

  double get totalDailyKWh => _deviceProvider?.totalDailyEnergyKWh ?? 0.0;

  double get totalActiveLoadWatts => _deviceProvider?.totalActiveLoadWatts ?? 0.0;

  double get currentTariff => _settingsProvider?.tariffRate ?? 7.50;

  /// Estimated electricity bill for today (in ₹)
  double get estimatedDailyCostRupees {
    return EnergyCalculationService.calculateEstimatedCost(
      totalEnergyKWh: totalDailyKWh,
      tariffRate: currentTariff,
    );
  }

  /// Estimated electricity bill projected for this month (in ₹)
  double get estimatedMonthlyBillRupees {
    return EnergyCalculationService.calculateProjectedMonthlyBill(
      dailyKWh: totalDailyKWh,
      tariffRate: currentTariff,
    );
  }

  /// Energy-saving percentage compared to an unmanaged baseline
  double get energySavingPercentage {
    return EnergyCalculationService.calculateEnergySavingsPercentage(
      currentDailyKWh: totalDailyKWh,
    );
  }

  /// Carbon emissions for today (in kg CO2)
  double get dailyCarbonKg {
    return EnergyCalculationService.calculateCO2EmissionsKg(totalDailyKWh);
  }

  /// Monthly trees equivalent
  double get monthlyTreesSaved {
    final monthlyKWh = EnergyCalculationService.calculateProjectedMonthlyKWh(totalDailyKWh);
    final baselineMonthlyKWh = 24.5 * 30.0;
    final savedKWh = (baselineMonthlyKWh - monthlyKWh).clamp(0.0, 500.0);
    final savedCO2 = EnergyCalculationService.calculateCO2EmissionsKg(savedKWh);
    return EnergyCalculationService.calculateTreesEquivalent(savedCO2);
  }

  List<HourlyConsumption> get hourlyCurve => _hourlyCurve;
  List<DailyConsumption> get past7Days => _past7Days;
  List<WeeklyConsumption> get past4Weeks => _past4Weeks;
  List<MonthlyConsumption> get past6Months => _past6Months;

  /// Percentage share of consumption by each device
  Map<DeviceModel, double> get deviceConsumptionShare {
    final devices = _deviceProvider?.devices ?? [];
    final totalKWh = totalDailyKWh;
    final Map<DeviceModel, double> share = {};

    if (totalKWh <= 0 || devices.isEmpty) return share;

    for (final dev in devices) {
      final percentage = (dev.dailyEnergyKWh / totalKWh) * 100.0;
      share[dev] = percentage;
    }
    return share;
  }

  /// Highest consuming device
  DeviceModel? get highestConsumingDevice => _deviceProvider?.highestConsumingDevice;

  /// Generate intelligent, dynamic energy insights based on live states
  List<EnergyInsight> get dynamicInsights {
    final List<EnergyInsight> insights = [];
    final devices = _deviceProvider?.devices ?? [];
    final activeWatts = totalActiveLoadWatts;
    final tariff = currentTariff;

    // 1. High Consumption Alert if AC & Water Heater are running concurrently or load > 2500W
    final isAcOn = devices.any((d) => d.iconName == 'ac' && d.isOn);
    final isGeyserOn = devices.any((d) => d.iconName == 'heater' && d.isOn);

    if (isAcOn && isGeyserOn) {
      final combinedWatts = 1450.0 + 2000.0;
      final hourlyKWh = combinedWatts / 1000.0;
      final costPerHour = hourlyKWh * tariff;

      insights.add(
        EnergyInsight(
          id: 'insight_alert_high_load',
          title: 'High Consumption Alert: Concurrent Heavy Loads',
          description:
              'Both the Air Conditioner (1,450 W) and Water Heater (2,000 W) are active simultaneously, '
              'drawing ~${combinedWatts.toStringAsFixed(0)} W. This costs ~₹${costPerHour.toStringAsFixed(1)}/hour '
              'and creates severe peak grid demand.',
          actionLabel: 'Turn Off Water Heater',
          severity: InsightSeverity.alert,
          icon: Icons.warning_amber_rounded,
          potentialSavingsRupees: costPerHour * 30, // Monthly if 1 hr/day
          potentialSavingsKWh: hourlyKWh * 30,
        ),
      );
    } else if (activeWatts > 2200) {
      insights.add(
        EnergyInsight(
          id: 'insight_alert_peak_load',
          title: 'Grid Peak Load Warning',
          description:
              'Active household load is currently ${activeWatts.toStringAsFixed(0)} W. '
              'Running multiple heavy appliances concurrently incurs high slab tariffs.',
          actionLabel: 'Optimize Load',
          severity: InsightSeverity.warning,
          icon: Icons.speed_rounded,
        ),
      );
    }

    // 2. Highest consuming appliance insight
    final highest = highestConsumingDevice;
    if (highest != null) {
      final monthlyCost = highest.dailyEnergyKWh * 30 * tariff;
      insights.add(
        EnergyInsight(
          id: 'insight_highest_consumer',
          title: 'Top Consumer: ${highest.name}',
          description:
              '${highest.name} accounts for ${highest.dailyEnergyKWh.toStringAsFixed(2)} kWh/day '
              '(estimated ₹${monthlyCost.toStringAsFixed(0)}/month), making up the single largest component '
              'of your electricity bill.',
          actionLabel: 'Review Schedule',
          severity: InsightSeverity.info,
          icon: Icons.pie_chart_rounded,
          potentialSavingsRupees: monthlyCost * 0.20,
          potentialSavingsKWh: highest.dailyEnergyKWh * 30 * 0.20,
        ),
      );
    }

    // 3. Standby & Idle Lights / Fans recommendation
    final areLightsOn = devices.any((d) => d.iconName == 'light' && d.isOn);
    final areFansOn = devices.any((d) => d.iconName == 'fan' && d.isOn);
    if (areLightsOn && areFansOn) {
      insights.add(
        EnergyInsight(
          id: 'insight_standby_lights',
          title: 'Switch Off Unused Living Space Lights',
          description:
              'Leaving room lighting and fans running in unoccupied areas consumes unnecessary energy. '
              'Trimming 2 idle hours daily saves ~4.8 kWh each month.',
          actionLabel: 'Turn Off Lights',
          severity: InsightSeverity.warning,
          icon: Icons.lightbulb_outline,
          potentialSavingsRupees: 4.8 * tariff,
          potentialSavingsKWh: 4.8,
        ),
      );
    }

    // 4. Inverter AC Temperature Optimization Tip
    insights.add(
      EnergyInsight(
        id: 'insight_ac_opt',
        title: 'Optimal AC Setpoint (24°C Rule)',
        description:
            'Setting your AC to 24°C instead of 18°C-20°C reduces compressor workload by up to 24%, '
            'saving an estimated ₹340 to ₹600 on your monthly electricity bill.',
        actionLabel: 'Learn More',
        severity: InsightSeverity.success,
        icon: Icons.thermostat_rounded,
        potentialSavingsRupees: 450.0,
        potentialSavingsKWh: 60.0,
      ),
    );

    // 5. SDG 12 Responsible Consumption Tip
    insights.add(
      EnergyInsight(
        id: 'insight_sdg_living',
        title: 'SDG 12: Responsible Consumption',
        description:
            'By proactively managing your smart devices, your household is on track to avoid '
            '~${(dailyCarbonKg * 30).toStringAsFixed(0)} kg of CO2 emissions this month.',
        actionLabel: 'View SDG Impact',
        severity: InsightSeverity.success,
        icon: Icons.eco_rounded,
      ),
    );

    return insights;
  }
}
