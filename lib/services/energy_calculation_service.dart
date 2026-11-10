import 'dart:math';
import '../models/device_model.dart';
import '../models/energy_model.dart';
import '../utils/constants.dart';

class EnergyCalculationService {
  /// Core Formula 1: Energy (kWh) = Power (Watts) × Operating Hours / 1000
  static double calculateEnergyKWh({
    required double powerWatts,
    required double operatingHours,
  }) {
    if (powerWatts <= 0 || operatingHours <= 0) return 0.0;
    return (powerWatts * operatingHours) / 1000.0;
  }

  /// Core Formula 2: Estimated Cost = Total Energy (kWh) × Electricity Tariff
  static double calculateEstimatedCost({
    required double totalEnergyKWh,
    required double tariffRate,
  }) {
    if (totalEnergyKWh <= 0 || tariffRate <= 0) return 0.0;
    return totalEnergyKWh * tariffRate;
  }

  /// Calculates total active power load drawn right now across all appliances
  static double calculateTotalActiveLoadWatts(List<DeviceModel> devices) {
    double total = 0.0;
    for (final device in devices) {
      if (device.isOn && device.isOnline) {
        total += device.powerRatingWatts;
      }
    }
    return total;
  }

  /// Calculates daily energy usage (in kWh) across all appliances
  static double calculateTotalDailyKWh(List<DeviceModel> devices) {
    double totalKWh = 0.0;
    for (final device in devices) {
      totalKWh += device.dailyEnergyKWh;
    }
    return totalKWh;
  }

  /// Calculates projected monthly energy consumption (in kWh)
  static double calculateProjectedMonthlyKWh(double dailyKWh) {
    return dailyKWh * 30.0;
  }

  /// Calculates projected monthly electricity bill (in ₹)
  static double calculateProjectedMonthlyBill({
    required double dailyKWh,
    required double tariffRate,
  }) {
    final monthlyKWh = calculateProjectedMonthlyKWh(dailyKWh);
    return calculateEstimatedCost(totalEnergyKWh: monthlyKWh, tariffRate: tariffRate);
  }

  /// Calculates energy saving percentage compared to unmanaged baseline
  /// Unmanaged households typically consume ~28-35 kWh/day with idle appliances
  static double calculateEnergySavingsPercentage({
    required double currentDailyKWh,
    double baselineDailyKWh = 24.5,
  }) {
    if (baselineDailyKWh <= 0) return 0.0;
    final saved = ((baselineDailyKWh - currentDailyKWh) / baselineDailyKWh) * 100.0;
    return saved.clamp(0.0, 75.0);
  }

  /// Calculates CO2 emissions in kg from electricity consumed
  static double calculateCO2EmissionsKg(double totalKWh) {
    return totalKWh * AppConstants.co2EmissionFactor;
  }

  /// Calculates trees equivalent required to absorb CO2 emissions
  static double calculateTreesEquivalent(double co2Kg) {
    if (co2Kg <= 0) return 0.0;
    return (co2Kg / AppConstants.treeAbsorptionPerYearKg) * 12.0; // monthly tree equiv
  }

  /// Generates realistic demo 24-hour load curve (simulated historical pattern)
  static List<HourlyConsumption> generateHourlyLoadCurve(double currentActiveWatts) {
    final List<HourlyConsumption> curve = [];
    // Typical household curve: low at night (0-6), morning peak (7-10), midday lull, evening peak (18-22)
    final hourlyMultipliers = [
      0.30, 0.28, 0.25, 0.25, 0.26, 0.35, // 00:00 - 05:00
      0.65, 1.10, 1.25, 1.05, 0.70, 0.60, // 06:00 - 11:00
      0.65, 0.70, 0.75, 0.65, 0.70, 0.90, // 12:00 - 17:00
      1.30, 1.45, 1.40, 1.20, 0.85, 0.50, // 18:00 - 23:00
    ];

    final baseLoad = max(currentActiveWatts, 350.0);

    for (int hour = 0; hour < 24; hour++) {
      final multiplier = hourlyMultipliers[hour];
      final watts = baseLoad * multiplier;
      final kwh = (watts * 1.0) / 1000.0;
      curve.add(HourlyConsumption(hour: hour, kwh: kwh, loadWatts: watts));
    }
    return curve;
  }

  /// Generates realistic 7-day daily history
  static List<DailyConsumption> generatePast7DaysHistory(double currentDailyKWh, double tariffRate) {
    final List<DailyConsumption> list = [];
    final now = DateTime.now();
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Realistic variance across last 7 days
    final variance = [-0.12, 0.08, -0.05, 0.15, 0.02, 0.22, 0.18];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = dayNames[date.weekday - 1];
      final v = variance[6 - i];
      final kwh = max(6.0, currentDailyKWh * (1.0 + v));
      final cost = calculateEstimatedCost(totalEnergyKWh: kwh, tariffRate: tariffRate);
      list.add(DailyConsumption(day: dayName, date: date, kwh: kwh, cost: cost));
    }
    return list;
  }

  /// Generates realistic 4-week history
  static List<WeeklyConsumption> generatePast4WeeksHistory(double currentDailyKWh, double tariffRate) {
    final weeklyBase = currentDailyKWh * 7.0;
    return [
      WeeklyConsumption(
        weekLabel: 'Week 1',
        kwh: weeklyBase * 0.92,
        cost: calculateEstimatedCost(totalEnergyKWh: weeklyBase * 0.92, tariffRate: tariffRate),
      ),
      WeeklyConsumption(
        weekLabel: 'Week 2',
        kwh: weeklyBase * 1.06,
        cost: calculateEstimatedCost(totalEnergyKWh: weeklyBase * 1.06, tariffRate: tariffRate),
      ),
      WeeklyConsumption(
        weekLabel: 'Week 3',
        kwh: weeklyBase * 0.88,
        cost: calculateEstimatedCost(totalEnergyKWh: weeklyBase * 0.88, tariffRate: tariffRate),
      ),
      WeeklyConsumption(
        weekLabel: 'Week 4',
        kwh: weeklyBase * 1.02,
        cost: calculateEstimatedCost(totalEnergyKWh: weeklyBase * 1.02, tariffRate: tariffRate),
      ),
    ];
  }

  /// Generates realistic 6-month history
  static List<MonthlyConsumption> generatePast6MonthsHistory(double currentDailyKWh, double tariffRate) {
    final monthlyBase = currentDailyKWh * 30.0;
    const months = ['Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];
    const multipliers = [1.25, 1.30, 1.15, 1.05, 0.92, 0.88]; // Summer AC peak to autumn

    return List.generate(6, (i) {
      final kwh = monthlyBase * multipliers[i];
      return MonthlyConsumption(
        monthLabel: months[i],
        kwh: kwh,
        cost: calculateEstimatedCost(totalEnergyKWh: kwh, tariffRate: tariffRate),
      );
    });
  }
}
