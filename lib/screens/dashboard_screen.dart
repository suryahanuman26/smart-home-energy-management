import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/device_provider.dart';
import '../providers/energy_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import '../widgets/consumption_chart.dart';
import '../widgets/device_card.dart';
import '../widgets/device_detail_sheet.dart';
import '../widgets/energy_summary_card.dart';
import '../widgets/quick_stats_grid.dart';
import '../widgets/sdg_banner_card.dart';
import 'main_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final deviceProvider = context.watch<DeviceProvider>();
    final energyProvider = context.watch<EnergyProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    if (deviceProvider.isLoading || settingsProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.electricGreen),
        ),
      );
    }

    final devices = deviceProvider.devices;
    final userProfile = settingsProvider.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Hello, ${userProfile.name.split(' ').first}',
                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.waving_hand_rounded, size: 16, color: Color(0xFFFBBF24)),
              ],
            ),
            Text(
              userProfile.homeName,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        actions: [
          // Simulated Demo Mode Tag
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.energyTeal.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.energyTeal.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.energyTeal,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'SIMULATION',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.energyTeal,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All smart appliances connected and synchronized.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.electricGreen,
        onRefresh: () async {
          await deviceProvider.loadDevices();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Energy Summary Card (kWh, ₹ bill, active load, saving %)
              EnergySummaryCard(
                activeLoadWatts: energyProvider.totalActiveLoadWatts,
                dailyEnergyKWh: energyProvider.totalDailyKWh,
                estimatedCostRupees: energyProvider.estimatedDailyCostRupees,
                activeDevicesCount: deviceProvider.activeDevicesCount,
                totalDevicesCount: deviceProvider.totalDevicesCount,
                energySavingPercentage: energyProvider.energySavingPercentage,
              ),

              const SizedBox(height: 18),

              // Quick Global ON/OFF Controls Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.power_settings_new_rounded, size: 16),
                      label: const Text('Turn All OFF'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.alertDanger,
                        side: const BorderSide(color: AppColors.alertDanger, width: 1.2),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        deviceProvider.turnAllOff();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('All smart appliances turned OFF.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.energy_savings_leaf_rounded, size: 16),
                      label: const Text('Eco Optimize'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.electricGreen,
                        foregroundColor: const Color(0xFF042F1A),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        deviceProvider.turnOffHeavyLoads();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Heavy loads turned off for optimal grid conservation.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Quick Stats 4-Grid
              QuickStatsGrid(
                activeDevicesCount: deviceProvider.activeDevicesCount,
                totalDevicesCount: deviceProvider.totalDevicesCount,
                monthlyEstimatedCost: energyProvider.estimatedMonthlyBillRupees,
                dailyCarbonKg: energyProvider.dailyCarbonKg,
                treesEquivalent: energyProvider.monthlyTreesSaved,
              ),

              const SizedBox(height: 22),

              // Daily Energy Consumption Chart Header & Container
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daily Consumption Curve',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () => MainScreen.navigateToTab(context, 2),
                    child: const Text('Detailed Analytics', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkNavyCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.darkNavyBorder : AppColors.lightBorder,
                  ),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '24-Hour Load Distribution',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                        Text(
                          'Current Load: ${energyProvider.totalActiveLoadWatts.toStringAsFixed(0)} W',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.electricGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ConsumptionChart(
                      type: ChartType.dailyHourly,
                      hourlyData: energyProvider.hourlyCurve,
                      currentTariff: energyProvider.currentTariff,
                      isMini: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Quick Device Controls (Top 4 devices)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quick Appliance Controls',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () => MainScreen.navigateToTab(context, 1),
                    child: const Text('View All (7)', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Grid of first 4 devices
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: devices.take(4).length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final dev = devices[index];
                  return DeviceCard(
                    device: dev,
                    onToggle: (_) => deviceProvider.toggleDevice(dev.id),
                    onTap: () => DeviceDetailSheet.show(context, dev),
                  );
                },
              ),

              const SizedBox(height: 22),

              // SDG Integration Banner Card
              SdgBannerCard(
                onLearnMore: () => MainScreen.navigateToTab(context, 3),
              ),

              const SizedBox(height: 20),

              // Demo Disclaimer Note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.darkNavyBorder : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppConstants.demoDisclaimer,
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.35,
                          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
