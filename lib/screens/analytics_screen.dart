import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device_model.dart';
import '../providers/device_provider.dart';
import '../providers/energy_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import '../widgets/consumption_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedTimeframe = 0; // 0: Daily (24h), 1: Weekly (7 Days), 2: Monthly (6 Mos)
  int _touchedPieIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final energyProvider = context.watch<EnergyProvider>();
    final deviceProvider = context.watch<DeviceProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    final tariff = settingsProvider.tariffRate;

    // Calculate aggregated metrics based on timeframe
    double totalUnitsKWh = 0.0;
    double totalCostRupees = 0.0;
    String timeframeLabel = 'Today';

    if (_selectedTimeframe == 0) {
      totalUnitsKWh = energyProvider.totalDailyKWh;
      totalCostRupees = energyProvider.estimatedDailyCostRupees;
      timeframeLabel = 'Today (24-Hour Active Cycle)';
    } else if (_selectedTimeframe == 1) {
      totalUnitsKWh = energyProvider.past7Days.fold(0.0, (acc, item) => acc + item.kwh);
      totalCostRupees = energyProvider.past7Days.fold(0.0, (acc, item) => acc + item.cost);
      timeframeLabel = 'Past 7 Days Aggregate';
    } else {
      totalUnitsKWh = energyProvider.past6Months.fold(0.0, (acc, item) => acc + item.kwh);
      totalCostRupees = energyProvider.past6Months.fold(0.0, (acc, item) => acc + item.cost);
      timeframeLabel = 'Past 6 Months Aggregate';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Energy report exported successfully.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeframe Segmented Switcher
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkNavyCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkNavyBorder : AppColors.lightBorder,
                ),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _buildTimeframeButton('Daily', 0, isDark),
                  _buildTimeframeButton('Weekly', 1, isDark),
                  _buildTimeframeButton('Monthly', 2, isDark),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Top Aggregate Metric Cards Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkNavyCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.darkNavyBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Units Consumed',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              totalUnitsKWh.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'kWh',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.electricGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeframeLabel,
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkNavyCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.darkNavyBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimated Electricity Cost',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${AppConstants.currencySymbol}${totalCostRupees.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.energyTeal,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'At ${AppConstants.currencySymbol}${tariff.toStringAsFixed(2)}/kWh tariff',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Chart Container
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkNavyCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.darkNavyBorder : AppColors.lightBorder,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedTimeframe == 0
                            ? 'Hourly Consumption Profile'
                            : (_selectedTimeframe == 1
                                ? '7-Day Daily Consumption'
                                : '6-Month Consumption Trend'),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.electricGreen.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Interactive',
                          style: TextStyle(
                            color: AppColors.electricGreen,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Touch data points to view exact unit usage and calculated costs',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Chart Switcher
                  if (_selectedTimeframe == 0)
                    ConsumptionChart(
                      type: ChartType.dailyHourly,
                      hourlyData: energyProvider.hourlyCurve,
                      currentTariff: tariff,
                    )
                  else if (_selectedTimeframe == 1)
                    ConsumptionChart(
                      type: ChartType.pastWeek,
                      weeklyData: energyProvider.past7Days,
                      currentTariff: tariff,
                    )
                  else
                    ConsumptionChart(
                      type: ChartType.pastMonth,
                      monthlyData: energyProvider.past6Months,
                      currentTariff: tariff,
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Individual Appliance Consumption Breakdown Section
            const Text(
              'Appliance Consumption Breakdown',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Distribution of electricity usage across household appliances',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 14),

            // Pie/Donut Chart & Legend
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkNavyCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.darkNavyBorder : AppColors.lightBorder,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 190,
                    child: _buildAppliancePieChart(deviceProvider.devices, isDark),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  // Breakdown List of Devices
                  ...deviceProvider.devices.map((dev) {
                    final share = energyProvider.deviceConsumptionShare[dev] ?? 0.0;
                    final cost = dev.dailyEnergyKWh * tariff;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Icon(dev.iconData, size: 18, color: dev.isOn ? AppColors.electricGreen : Colors.grey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dev.name,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${dev.dailyEnergyKWh.toStringAsFixed(2)} kWh/day • ${dev.powerRatingWatts.toStringAsFixed(0)}W',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${share.toStringAsFixed(1)}%',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                '${AppConstants.currencySymbol}${cost.toStringAsFixed(1)}/day',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeframeButton(String label, int index, bool isDark) {
    final isSelected = _selectedTimeframe == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTimeframe = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.electricGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF042F1A)
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppliancePieChart(List<DeviceModel> devices, bool isDark) {
    if (devices.isEmpty) return const SizedBox.shrink();

    final colors = [
      const Color(0xFF00E676),
      const Color(0xFF00E5FF),
      const Color(0xFFF59E0B),
      const Color(0xFFEC4899),
      const Color(0xFF8B5CF6),
      const Color(0xFF3B82F6),
      const Color(0xFF10B981),
    ];

    final totalKwh = devices.fold(0.0, (acc, d) => acc + d.dailyEnergyKWh);

    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                _touchedPieIndex = -1;
                return;
              }
              _touchedPieIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 3,
        centerSpaceRadius: 46,
        sections: devices.asMap().entries.map((entry) {
          final idx = entry.key;
          final dev = entry.value;
          final isTouched = idx == _touchedPieIndex;
          final radius = isTouched ? 48.0 : 40.0;
          final percentage = totalKwh > 0 ? (dev.dailyEnergyKWh / totalKwh) * 100 : 0.0;

          return PieChartSectionData(
            color: colors[idx % colors.length],
            value: dev.dailyEnergyKWh,
            title: percentage > 8 ? '${percentage.toStringAsFixed(0)}%' : '',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          );
        }).toList(),
      ),
    );
  }
}
