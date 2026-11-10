import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../utils/constants.dart';

class DeviceCard extends StatelessWidget {
  final DeviceModel device;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onTap;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOn = device.isOn;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkNavyCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isOn
              ? AppColors.electricGreen.withOpacity(0.5)
              : (isDark ? AppColors.darkNavyBorder : AppColors.lightBorder),
          width: isOn ? 1.5 : 1.0,
        ),
        boxShadow: [
          if (isOn)
            BoxShadow(
              color: AppColors.electricGreen.withOpacity(isDark ? 0.12 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            )
          else
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top row: Appliance Icon + Status pill + ON/OFF Switch
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Glowing Icon Container
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isOn
                            ? AppColors.electricGreen.withOpacity(0.18)
                            : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04)),
                        shape: BoxShape.circle,
                        boxShadow: isOn
                            ? [
                                BoxShadow(
                                  color: AppColors.electricGreen.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                )
                              ]
                            : null,
                      ),
                      child: Icon(
                        device.iconData,
                        size: 24,
                        color: isOn
                            ? AppColors.electricGreen
                            : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Room Tag
                    Expanded(
                      child: Text(
                        device.room,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Working ON/OFF Switch
                    Transform.scale(
                      scale: 0.85,
                      child: Switch(
                        value: isOn,
                        onChanged: onToggle,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Middle section: Device Name & Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isOn ? AppColors.electricGreen : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          device.statusText,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: isOn
                                ? (isDark ? AppColors.electricGreen : const Color(0xFF047857))
                                : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Bottom row: Current Watts & Daily energy (kWh)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkNavySurface : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Current Power
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Power Draw',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                            ),
                          ),
                          Text(
                            '${device.currentPowerWatts.toStringAsFixed(0)} W',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isOn
                                  ? AppColors.electricGreen
                                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                            ),
                          ),
                        ],
                      ),
                      // Daily Energy
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Daily Est.',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                            ),
                          ),
                          Text(
                            '${device.dailyEnergyKWh.toStringAsFixed(2)} kWh',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
