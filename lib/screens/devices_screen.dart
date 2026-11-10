import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/device_provider.dart';
import '../utils/constants.dart';
import '../widgets/device_card.dart';
import '../widgets/device_detail_sheet.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  String _selectedRoom = 'All';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final deviceProvider = context.watch<DeviceProvider>();
    final devices = deviceProvider.getDevicesForRoom(_selectedRoom);
    final rooms = deviceProvider.availableRooms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Management'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (val) {
              if (val == 'all_on') {
                deviceProvider.turnAllOn();
              } else if (val == 'all_off') {
                deviceProvider.turnAllOff();
              } else if (val == 'reset') {
                deviceProvider.resetToDefaults();
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'all_on',
                child: Row(
                  children: [
                    Icon(Icons.power_rounded, color: AppColors.electricGreen, size: 18),
                    SizedBox(width: 8),
                    Text('Turn All ON'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'all_off',
                child: Row(
                  children: [
                    Icon(Icons.power_off_rounded, color: AppColors.alertDanger, size: 18),
                    SizedBox(width: 8),
                    Text('Turn All OFF'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.restart_alt_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Reset Appliance States'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Summary Banner: Active Load & Count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkNavyCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkNavyBorder : AppColors.lightBorder,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Active Draw',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${deviceProvider.totalActiveLoadWatts.toStringAsFixed(0)} W',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.electricGreen,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 30,
                  width: 1,
                  color: isDark ? AppColors.darkNavyBorder : AppColors.lightBorder,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Appliances Active',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${deviceProvider.activeDevicesCount} of ${deviceProvider.totalDevicesCount}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 30,
                  width: 1,
                  color: isDark ? AppColors.darkNavyBorder : AppColors.lightBorder,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Daily Forecast',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${deviceProvider.totalDailyEnergyKWh.toStringAsFixed(1)} kWh',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.energyTeal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Room Filter Chips
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: rooms.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final room = rooms[index];
                final isSelected = _selectedRoom == room;

                return ChoiceChip(
                  label: Text(room),
                  selected: isSelected,
                  selectedColor: AppColors.electricGreen,
                  backgroundColor: isDark ? AppColors.darkNavyCard : AppColors.lightCard,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF042F1A)
                        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.electricGreen
                        : (isDark ? AppColors.darkNavyBorder : AppColors.lightBorder),
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedRoom = room);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Appliances Grid
          Expanded(
            child: devices.isEmpty
                ? Center(
                    child: Text(
                      'No appliances found in this room',
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    itemCount: devices.length,
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
          ),
        ],
      ),
    );
  }
}
