import 'package:flutter/material.dart';
import '../utils/constants.dart';

class QuickStatsGrid extends StatelessWidget {
  final int activeDevicesCount;
  final int totalDevicesCount;
  final double monthlyEstimatedCost;
  final double dailyCarbonKg;
  final double treesEquivalent;

  const QuickStatsGrid({
    super.key,
    required this.activeDevicesCount,
    required this.totalDevicesCount,
    required this.monthlyEstimatedCost,
    required this.dailyCarbonKg,
    required this.treesEquivalent,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.55,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          context,
          title: 'Connected Grid',
          value: '$activeDevicesCount / $totalDevicesCount',
          subtitle: 'Appliances Running',
          icon: Icons.power_rounded,
          iconColor: AppColors.electricGreen,
        ),
        _buildStatCard(
          context,
          title: 'Projected Month',
          value: '${AppConstants.currencySymbol}${monthlyEstimatedCost.toStringAsFixed(0)}',
          subtitle: 'Billing Forecast',
          icon: Icons.receipt_long_rounded,
          iconColor: AppColors.energyTeal,
        ),
        _buildStatCard(
          context,
          title: 'Daily Carbon',
          value: '${dailyCarbonKg.toStringAsFixed(1)} kg',
          subtitle: 'CO2 Footprint',
          icon: Icons.cloud_outlined,
          iconColor: AppColors.alertWarning,
        ),
        _buildStatCard(
          context,
          title: 'Eco Offset',
          value: '${treesEquivalent.toStringAsFixed(1)}',
          subtitle: 'Trees Equivalent',
          icon: Icons.park_rounded,
          iconColor: AppColors.alertSuccess,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkNavyCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkNavyBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 14, color: iconColor),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
