import 'package:flutter/material.dart';
import 'app.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent storage service
  final storageService = StorageService();
  await storageService.init();

  runApp(SmartHomeEnergyApp(storageService: storageService));
}
