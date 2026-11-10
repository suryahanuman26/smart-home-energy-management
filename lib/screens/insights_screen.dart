import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/energy_model.dart';
import '../providers/device_provider.dart';
import '../providers/energy_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import 'main_screen.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final energyProvider = context.watch<EnergyProvider>();
    final deviceProvider = context.watch<DeviceProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    final highestDev = energyProvider.highestConsumingDevice;
    final insights = energyProvider.dynamicInsights;
    final tariff = settingsProvider.tariffRate;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Insights & SDG'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Highest Consuming Appliance Hero Card
            if (highestDev != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF2E1A1A), const Color(0xFF1F151F), AppColors.darkNavyCard]
                        : [const Color(0xFFFFEDEC), const Color(0xFFFFF1F1), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: AppColors.alertDanger.withOpacity(0.4),
                    width: 1.2,
                  ),
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.alertDanger.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_fire_department_rounded,
                            color: AppColors.alertDanger,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Highest Power Consumer',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.alertDanger,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.alertDanger.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            highestDev.isOn ? 'RUNNING NOW' : 'STANDBY',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.alertDanger,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      highestDev.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rated at ${highestDev.powerRatingWatts.toStringAsFixed(0)} Watts • Typical runtime: ${highestDev.defaultDailyHours.toStringAsFixed(1)} hrs/day',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _buildHeroStat(
                          label: 'Daily Consumption',
                          value: '${highestDev.dailyEnergyKWh.toStringAsFixed(2)} kWh',
                          isDark: isDark,
                        ),
                        const SizedBox(width: 12),
                        _buildHeroStat(
                          label: 'Monthly Cost',
                          value: '${AppConstants.currencySymbol}${(highestDev.dailyEnergyKWh * 30 * tariff).toStringAsFixed(0)}',
                          isDark: isDark,
                          valueColor: AppColors.alertDanger,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // 2. Real-time Smart Insights & Alerts
            const Text(
              'Smart Recommendations & Alerts',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Dynamic suggestions based on active power usage and schedule',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 12),

            ...insights.map((insight) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkNavyCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: insight.accentColor.withOpacity(0.35),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: insight.accentColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(insight.icon, color: insight.accentColor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            insight.title,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      insight.description,
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    if (insight.potentialSavingsRupees > 0) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.electricGreen.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.savings_outlined,
                              color: AppColors.electricGreen,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Potential Savings: ${AppConstants.currencySymbol}${insight.potentialSavingsRupees.toStringAsFixed(0)} / month',
                              style: const TextStyle(
                                color: AppColors.electricGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          if (insight.id == 'insight_alert_high_load') {
                            // Turn off water heater safely
                            final matching = deviceProvider.devices.where((d) => d.iconName == 'heater');
                            if (matching.isNotEmpty) {
                              deviceProvider.toggleDevice(matching.first.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Water Heater turned OFF to optimize grid load.'),
                                ),
                              );
                            }
                          } else if (insight.id == 'insight_standby_lights') {
                            final matching = deviceProvider.devices.where((d) => d.iconName == 'light');
                            if (matching.isNotEmpty) {
                              deviceProvider.toggleDevice(matching.first.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Living room lights turned OFF.'),
                                ),
                              );
                            }
                          } else {
                            MainScreen.navigateToTab(context, 1);
                          }
                        },
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          foregroundColor: insight.accentColor,
                        ),
                        child: Text(
                          insight.actionLabel,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // 3. Detailed UN SDG Integration Section
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF132A1F), const Color(0xFF0F2018), AppColors.darkNavyCard]
                      : [const Color(0xFFE8F8F0), const Color(0xFFF0FDF4), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: AppColors.sdg13Green.withOpacity(0.5),
                  width: 1.2,
                ),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.sdg13Green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.eco_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'UN Sustainable Development Goals',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Smart energy monitoring empowers citizens to curb unnecessary consumption, '
                    'reducing grid load and preventing thermal power plant carbon emissions.',
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Goal 7
                  _buildSdgTile(
                    number: 'SDG 7',
                    title: 'Affordable & Clean Energy',
                    desc:
                        'Avoids grid congestion by optimizing household demand curves, making renewable energy integration smoother.',
                    color: AppColors.sdg7Yellow,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),

                  // Goal 12
                  _buildSdgTile(
                    number: 'SDG 12',
                    title: 'Responsible Consumption & Production',
                    desc:
                        'Eliminates idle standby wattage and encourages conscious, measured appliance operation.',
                    color: AppColors.sdg12Orange,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),

                  // Goal 13
                  _buildSdgTile(
                    number: 'SDG 13',
                    title: 'Climate Action',
                    desc:
                        'Every 1 kWh saved prevents 0.82 kg of CO2 release into our atmosphere. Small home habits multiply into national climate resilience.',
                    color: AppColors.sdg13Green,
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroStat({
    required String label,
    required String value,
    required bool isDark,
    Color? valueColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkNavySurface : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkNavyBorder : AppColors.lightBorder,
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
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSdgTile({
    required String number,
    required String title,
    required String desc,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkNavyCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.35,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
