import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/energy_model.dart';
import '../providers/device_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settingsProvider = context.watch<SettingsProvider>();
    final deviceProvider = context.watch<DeviceProvider>();
    final profile = settingsProvider.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Configuration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkNavyCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.darkNavyBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.electricGreen.withOpacity(0.2),
                    child: const Text(
                      'SS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.electricGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          profile.email,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Meter ID: ${profile.meterId}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.energyTeal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    onPressed: () => _showEditProfileDialog(context, settingsProvider),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Electricity Tariff Settings (₹ per kWh)
            const Text(
              'Electricity Tariff & Billing',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkNavyCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.darkNavyBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Unit Tariff Rate',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Electricity board cost per kWh',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.electricGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.electricGreen.withOpacity(0.3)),
                        ),
                        child: Text(
                          '${AppConstants.currencySymbol}${settingsProvider.tariffRate.toStringAsFixed(2)} / kWh',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.electricGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Slider(
                    value: settingsProvider.tariffRate,
                    min: 3.0,
                    max: 15.0,
                    divisions: 24,
                    label: '${AppConstants.currencySymbol}${settingsProvider.tariffRate.toStringAsFixed(2)}',
                    onChanged: (val) {
                      settingsProvider.setTariffRate(val);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Min: ${AppConstants.currencySymbol}3.00',
                          style: TextStyle(fontSize: 10, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                      Text('Commercial avg: ${AppConstants.currencySymbol}9.50',
                          style: TextStyle(fontSize: 10, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                      Text('Max: ${AppConstants.currencySymbol}15.00',
                          style: TextStyle(fontSize: 10, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // App Appearance & Theme Selection
            const Text(
              'Appearance & Theme',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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
              child: SwitchListTile(
                title: const Text('Dark Navy Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text(
                  isDark ? 'Electric green on dark navy dashboard' : 'Light modern UI activated',
                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                ),
                secondary: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: AppColors.electricGreen,
                ),
                value: settingsProvider.isDarkMode,
                onChanged: (val) {
                  settingsProvider.setDarkMode(val);
                },
              ),
            ),

            const SizedBox(height: 20),

            // Notifications & Smart Alerts Preferences
            const Text(
              'Notifications & Alerts',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('High Consumption Alerts', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      'Notify when active power draw exceeds 2,200W',
                      style: TextStyle(fontSize: 11, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    ),
                    secondary: const Icon(Icons.warning_amber_rounded, color: AppColors.alertWarning),
                    value: settingsProvider.notificationsEnabled,
                    onChanged: (val) => settingsProvider.setNotifications(val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Autonomous Eco Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      'Auto-suggest turning off idle loads during peak grid hours',
                      style: TextStyle(fontSize: 11, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    ),
                    secondary: const Icon(Icons.energy_savings_leaf_rounded, color: AppColors.electricGreen),
                    value: settingsProvider.ecoModeEnabled,
                    onChanged: (val) => settingsProvider.setEcoMode(val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Data Management: Reset Demo Data
            const Text(
              'Demo Data Management',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkNavyCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.darkNavyBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reset Simulated Demo Data',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Restores all 7 smart appliances to their default states and resets custom tariff configurations.',
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.35,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.restore_rounded, size: 16),
                    label: const Text('Reset Demo Data'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.alertDanger,
                      side: const BorderSide(color: AppColors.alertDanger),
                    ),
                    onPressed: () => _confirmResetDialog(context, deviceProvider, settingsProvider),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // App Specs & Version Footer
            Center(
              child: Column(
                children: [
                  Text(
                    '${AppConstants.appName} System v${AppConstants.appVersion}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Clean Architecture with Flutter & Provider',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static void _confirmResetDialog(
    BuildContext context,
    DeviceProvider deviceProvider,
    SettingsProvider settingsProvider,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Demo Data?'),
        content: const Text(
          'This will restore all appliances to initial states, '
          'reset tariff to ₹7.50/kWh, and re-populate the demo history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.alertDanger),
            onPressed: () async {
              await deviceProvider.resetToDefaults();
              await settingsProvider.resetToDefaults();
              if (ctx.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Demo data has been reset to defaults.')),
                );
              }
            },
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static void _showEditProfileDialog(
    BuildContext context,
    SettingsProvider settingsProvider,
  ) {
    final nameCtrl = TextEditingController(text: settingsProvider.userProfile.name);
    final emailCtrl = TextEditingController(text: settingsProvider.userProfile.email);
    final homeCtrl = TextEditingController(text: settingsProvider.userProfile.homeName);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email Address'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: homeCtrl,
              decoration: const InputDecoration(labelText: 'Home / Unit Name'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              settingsProvider.updateProfile(
                name: nameCtrl.text.trim(),
                email: emailCtrl.text.trim(),
                homeName: homeCtrl.text.trim(),
              );
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
