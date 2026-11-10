import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home_energy/models/device_model.dart';
import 'package:smart_home_energy/services/energy_calculation_service.dart';

void main() {
  group('EnergyCalculationService Unit Tests', () {
    test('calculateEnergyKWh follows formula: Power (W) * Hours / 1000', () {
      // 1500 Watts AC running for 6 hours = 9.0 kWh
      final kwh = EnergyCalculationService.calculateEnergyKWh(
        powerWatts: 1500.0,
        operatingHours: 6.0,
      );
      expect(kwh, closeTo(9.0, 0.001));

      // 40 Watts LED light running for 5 hours = 0.2 kWh
      final lightKwh = EnergyCalculationService.calculateEnergyKWh(
        powerWatts: 40.0,
        operatingHours: 5.0,
      );
      expect(lightKwh, closeTo(0.2, 0.001));

      // Negative or zero check
      expect(
        EnergyCalculationService.calculateEnergyKWh(powerWatts: 0, operatingHours: 5),
        0.0,
      );
      expect(
        EnergyCalculationService.calculateEnergyKWh(powerWatts: 100, operatingHours: 0),
        0.0,
      );
    });

    test('calculateEstimatedCost follows formula: Total Energy (kWh) * Tariff Rate', () {
      // 10 kWh * ₹7.50 tariff = ₹75.00
      final cost = EnergyCalculationService.calculateEstimatedCost(
        totalEnergyKWh: 10.0,
        tariffRate: 7.50,
      );
      expect(cost, closeTo(75.0, 0.001));

      // 18.5 kWh * ₹8.25 tariff = ₹152.625
      final cost2 = EnergyCalculationService.calculateEstimatedCost(
        totalEnergyKWh: 18.5,
        tariffRate: 8.25,
      );
      expect(cost2, closeTo(152.625, 0.001));

      // Zero energy or tariff returns 0
      expect(
        EnergyCalculationService.calculateEstimatedCost(totalEnergyKWh: 0, tariffRate: 7.5),
        0.0,
      );
    });

    test('calculateTotalActiveLoadWatts sums only active appliances', () {
      const devices = [
        DeviceModel(
          id: '1',
          name: 'AC',
          category: DeviceCategory.cooling,
          room: 'Bedroom',
          powerRatingWatts: 1500.0,
          defaultDailyHours: 6.0,
          isOn: true,
          iconName: 'ac',
        ),
        DeviceModel(
          id: '2',
          name: 'Fan',
          category: DeviceCategory.cooling,
          room: 'Living Room',
          powerRatingWatts: 50.0,
          defaultDailyHours: 8.0,
          isOn: false, // OFF: should not be included
          iconName: 'fan',
        ),
        DeviceModel(
          id: '3',
          name: 'TV',
          category: DeviceCategory.entertainment,
          room: 'Living Room',
          powerRatingWatts: 100.0,
          defaultDailyHours: 4.0,
          isOn: true,
          iconName: 'tv',
        ),
      ];

      final totalLoad = EnergyCalculationService.calculateTotalActiveLoadWatts(devices);
      // 1500 + 100 = 1600 W
      expect(totalLoad, equals(1600.0));
    });

    test('calculateEnergySavingsPercentage computes correct conservation metric', () {
      // Current 14.7 kWh vs 24.5 kWh baseline = 40% saved
      final savings = EnergyCalculationService.calculateEnergySavingsPercentage(
        currentDailyKWh: 14.7,
        baselineDailyKWh: 24.5,
      );
      expect(savings, closeTo(40.0, 0.1));
    });

    test('calculateCO2EmissionsKg computes 0.82 kg per kWh', () {
      final co2 = EnergyCalculationService.calculateCO2EmissionsKg(10.0);
      expect(co2, closeTo(8.20, 0.001));
    });
  });
}
