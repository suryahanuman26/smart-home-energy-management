import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device_model.dart';
import '../providers/device_provider.dart';
import '../providers/settings_provider.dart';
import '../services/energy_calculation_service.dart';
import '../utils/constants.dart';

class DeviceDetailSheet extends StatefulWidget {
  final DeviceModel device;

  const DeviceDetailSheet({super.key, required this.device});

  static void show(BuildContext context, DeviceModel device) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DeviceDetailSheet(device: device),
    );
  }

  @override
  State<DeviceDetailSheet> createState() => _DeviceDetailSheetState();
}

class _DeviceDetailSheetState extends State<DeviceDetailSheet> {
  late double _hours;

  @override
  void initState() {
    super.initState();
    _hours = widget.device.defaultDailyHours;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final deviceProvider = context.watch<DeviceProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    // Fetch latest instance of this device from provider
    final currentDevice = deviceProvider.devices.firstWhere(
      (d) => d.id == widget.device.id,
      orElse: () => widget.device,
    );

    final tariff = settingsProvider.tariffRate;
    final dailyKWh = EnergyCalculationService.calculateEnergyKWh(
      powerWatts: currentDevice.powerRatingWatts,
      operatingHours: _hours,
    );
    final dailyCost = EnergyCalculationService.calculateEstimatedCost(
      totalEnergyKWh: dailyKWh,
      tariffRate: tariff,
    );
    final monthlyCost = dailyCost * 30.0;

    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 24, left: 20, right: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkNavySurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            // Header: Icon + Name + Switch
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: currentDevice.isOn
                        ? AppColors.electricGreen.withOpacity(0.18)
                        : Colors.white10,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    currentDevice.iconData,
                    size: 28,
                    color: currentDevice.isOn ? AppColors.electricGreen : Colors.grey,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentDevice.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${currentDevice.room} • ${currentDevice.powerRatingWatts.toStringAsFixed(0)} W Rated',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: currentDevice.isOn,
                  onChanged: (val) {
                    deviceProvider.toggleDevice(currentDevice.id);
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Operating Hours Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daily Operating Schedule',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${_hours.toStringAsFixed(1)} hrs/day',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.electricGreen,
                  ),
                ),
              ],
            ),
            Slider(
              value: _hours,
              min: 0.5,
              max: 24.0,
              divisions: 47,
              label: '${_hours.toStringAsFixed(1)} h',
              onChanged: (newVal) {
                setState(() => _hours = newVal);
              },
              onChangeEnd: (finalVal) {
                deviceProvider.updateDeviceHours(currentDevice.id, finalVal);
              },
            ),

            const SizedBox(height: 14),

            // Metrics Summary Grid for this device
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    label: 'Daily Energy',
                    value: '${dailyKWh.toStringAsFixed(2)} kWh',
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricTile(
                    label: 'Daily Cost',
                    value: '${AppConstants.currencySymbol}${dailyCost.toStringAsFixed(1)}',
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricTile(
                    label: 'Monthly Est.',
                    value: '${AppConstants.currencySymbol}${monthlyCost.toStringAsFixed(0)}',
                    isDark: isDark,
                    valueColor: AppColors.energyTeal,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Conservation Tip
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.electricGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.electricGreen.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.eco_outlined, color: AppColors.electricGreen, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Reducing daily usage by 1 hour saves ~${(currentDevice.powerRatingWatts / 1000.0 * 30 * tariff).toStringAsFixed(0)} ${AppConstants.currencySymbol} and avoids ~${(currentDevice.powerRatingWatts / 1000.0 * 30 * 0.82).toStringAsFixed(1)} kg CO2 emissions per month.',
                      style: const TextStyle(fontSize: 11, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required bool isDark,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkNavyCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkNavyBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            ),
          ),
        ],
      ),
    );
  }
}
