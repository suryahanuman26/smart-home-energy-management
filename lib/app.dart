import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/device_provider.dart';
import 'providers/energy_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/splash_screen.dart';
import 'services/storage_service.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';

class SmartHomeEnergyApp extends StatelessWidget {
  final StorageService storageService;

  const SmartHomeEnergyApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(storageService: storageService)..loadSettings(),
        ),
        ChangeNotifierProvider<DeviceProvider>(
          create: (_) => DeviceProvider(storageService: storageService)..loadDevices(),
        ),
        ChangeNotifierProxyProvider2<DeviceProvider, SettingsProvider, EnergyProvider>(
          create: (_) => EnergyProvider(),
          update: (_, deviceProv, settingsProv, energyProv) {
            final provider = energyProv ?? EnergyProvider();
            provider.update(deviceProv, settingsProv);
            return provider;
          },
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
