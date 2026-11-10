import 'package:flutter/material.dart';
import '../utils/constants.dart';

class EnergySummaryCard extends StatelessWidget {
  final double activeLoadWatts;
  final double dailyEnergyKWh;
  final double estimatedCostRupees;
  final int activeDevicesCount;
  final int totalDevicesCount;
  final double energySavingPercentage;

  const EnergySummaryCard({
    super.key,
    required this.activeLoadWatts,
    required this.dailyEnergyKWh,
    required this.estimatedCostRupees,
    required this.activeDevicesCount,
    required this.totalDevicesCount,
    required this.energySavingPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF10233D),
                  const Color(0xFF0D1B2A),
                  const Color(0xFF0B1422),
                ]
              : [
                  const Color(0xFF1E3A5F),
                  const Color(0xFF0F2B48),
                  const Color(0xFF091E33),
                ],
        ),
        border: Border.all(
          color: AppColors.electricGreen.withOpacity(0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.electricGreen.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background ambient energy glow
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.electricGreen.withOpacity(0.12),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Live Active Load Indicator + Eco Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.electricGreen.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.electricGreen.withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.electricGreen,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'ACTIVE LOAD',
                                style: const TextStyle(
                                  color: AppColors.electricGreen,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${activeLoadWatts.toStringAsFixed(0)} W',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    // Energy Saving Percentage Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.trending_down_rounded,
                            color: AppColors.electricGreen,
                            size: 15,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '-${energySavingPercentage.toStringAsFixed(1)}% Saved',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Hero Electricity Consumption
                Text(
                  'Today\'s Consumption',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      dailyEnergyKWh.toStringAsFixed(2),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'kWh',
                      style: TextStyle(
                        color: AppColors.electricGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    // Estimated Cost in Rupees
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Est. Bill Today',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${AppConstants.currencySymbol}${estimatedCostRupees.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppColors.energyTeal,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 14),

                // Bottom Quick Summary Pills
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Active Devices Indicator
                    Row(
                      children: [
                        const Icon(
                          Icons.devices_rounded,
                          color: AppColors.electricGreen,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Active Appliances: ',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '$activeDevicesCount of $totalDevicesCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    // Grid Status Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: activeLoadWatts > 2200
                            ? AppColors.alertWarning.withOpacity(0.2)
                            : AppColors.electricGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        activeLoadWatts > 2200 ? 'PEAK LOAD' : 'OPTIMAL LOAD',
                        style: TextStyle(
                          color: activeLoadWatts > 2200
                              ? AppColors.alertWarning
                              : AppColors.electricGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
