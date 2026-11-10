import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/energy_model.dart';
import '../utils/constants.dart';

enum ChartType { dailyHourly, pastWeek, pastMonth }

class ConsumptionChart extends StatelessWidget {
  final ChartType type;
  final List<HourlyConsumption>? hourlyData;
  final List<DailyConsumption>? weeklyData;
  final List<MonthlyConsumption>? monthlyData;
  final double currentTariff;
  final bool isMini;

  const ConsumptionChart({
    super.key,
    required this.type,
    this.hourlyData,
    this.weeklyData,
    this.monthlyData,
    this.currentTariff = 7.50,
    this.isMini = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AspectRatio(
      aspectRatio: isMini ? 1.8 : 1.5,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 6, top: 12, bottom: 6),
        child: type == ChartType.dailyHourly
            ? _buildHourlyLineChart(isDark)
            : _buildBarChart(isDark),
      ),
    );
  }

  Widget _buildHourlyLineChart(bool isDark) {
    final data = hourlyData ?? [];
    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final spots = data.map((e) => FlSpot(e.hour.toDouble(), e.kwh)).toList();
    final maxKwh = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final maxY = (maxKwh * 1.3).clamp(1.0, 10.0);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: !isMini,
          drawVerticalLine: false,
          horizontalInterval: (maxY / 4).clamp(0.2, 5.0),
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark ? Colors.white10 : Colors.black12,
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: !isMini,
              reservedSize: 36,
              interval: (maxY / 4).clamp(0.2, 5.0),
              getTitlesWidget: (value, meta) {
                if (value == meta.max || value == meta.min) return const SizedBox.shrink();
                return Text(
                  value.toStringAsFixed(1),
                  style: TextStyle(
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: isMini ? 6 : 4,
              getTitlesWidget: (value, meta) {
                final hour = value.toInt();
                if (hour % (isMini ? 6 : 4) != 0 || hour > 23) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '${hour.toString().padLeft(2, '0')}:00',
                    style: TextStyle(
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 23,
        minY: 0,
        maxY: maxY,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => isDark ? AppColors.darkNavyCardElevated : Colors.white,
            tooltipRoundedRadius: 8,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final cost = spot.y * currentTariff;
                return LineTooltipItem(
                  '${spot.x.toInt()}:00\n${spot.y.toStringAsFixed(2)} kWh\n${AppConstants.currencySymbol}${cost.toStringAsFixed(2)}',
                  TextStyle(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: AppColors.electricGreen,
            barWidth: 2.8,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.electricGreen.withOpacity(0.35),
                  AppColors.electricGreen.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(bool isDark) {
    if (type == ChartType.pastWeek) {
      final data = weeklyData ?? [];
      if (data.isEmpty) return const Center(child: Text('No data available'));

      final maxY = (data.map((e) => e.kwh).reduce((a, b) => a > b ? a : b) * 1.25).clamp(1.0, 50.0);

      return BarChart(
        BarChartData(
          maxY: maxY,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => isDark ? AppColors.darkNavyCardElevated : Colors.white,
              tooltipRoundedRadius: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final item = data[group.x.toInt()];
                return BarTooltipItem(
                  '${item.day}\n${item.kwh.toStringAsFixed(1)} kWh\n${AppConstants.currencySymbol}${item.cost.toStringAsFixed(1)}',
                  TextStyle(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: (maxY / 4).clamp(1.0, 15.0),
                getTitlesWidget: (value, meta) {
                  if (value == meta.max || value == meta.min) return const SizedBox.shrink();
                  return Text(
                    value.toStringAsFixed(0),
                    style: TextStyle(
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      data[idx].day,
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY / 4).clamp(1.0, 15.0),
            getDrawingHorizontalLine: (value) => FlLine(
              color: isDark ? Colors.white10 : Colors.black12,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: data.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final isLatest = idx == data.length - 1;

            return BarChartGroupData(
              x: idx,
              barRods: [
                BarChartRodData(
                  toY: item.kwh,
                  color: isLatest ? AppColors.electricGreen : AppColors.energyTeal.withOpacity(0.7),
                  width: 14,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      );
    } else {
      // Monthly Bar Chart
      final data = monthlyData ?? [];
      if (data.isEmpty) return const Center(child: Text('No data available'));

      final maxY = (data.map((e) => e.kwh).reduce((a, b) => a > b ? a : b) * 1.2).clamp(50.0, 1000.0);

      return BarChart(
        BarChartData(
          maxY: maxY,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => isDark ? AppColors.darkNavyCardElevated : Colors.white,
              tooltipRoundedRadius: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final item = data[group.x.toInt()];
                return BarTooltipItem(
                  '${item.monthLabel}\n${item.kwh.toStringAsFixed(0)} kWh\n${AppConstants.currencySymbol}${item.cost.toStringAsFixed(0)}',
                  TextStyle(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 34,
                interval: (maxY / 4).clamp(10.0, 250.0),
                getTitlesWidget: (value, meta) {
                  if (value == meta.max || value == meta.min) return const SizedBox.shrink();
                  return Text(
                    value.toStringAsFixed(0),
                    style: TextStyle(
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      data[idx].monthLabel,
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY / 4).clamp(10.0, 250.0),
            getDrawingHorizontalLine: (value) => FlLine(
              color: isDark ? Colors.white10 : Colors.black12,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: data.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;

            return BarChartGroupData(
              x: idx,
              barRods: [
                BarChartRodData(
                  toY: item.kwh,
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF0072FF),
                      AppColors.energyTeal,
                    ],
                  ),
                  width: 18,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            );
          }).toList(),
        ),
      );
    }
  }
}
