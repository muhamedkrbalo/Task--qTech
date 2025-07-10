import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:step_counter/core/service_locator/service_locator.dart';
import 'package:step_counter/core/services/background_service.dart';
import 'package:step_counter/core/services/notification_service.dart';
import 'package:step_counter/firebase_options.dart';

class ServiceInitialize {
  ServiceInitialize._();
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await setupDependencies();
    await NotificationService.initialize();
    await BackgroundService.initialize();
  }
}
