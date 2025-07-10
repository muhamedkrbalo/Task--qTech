import 'package:step_counter/core/service_locator/service_locator.dart';
import 'package:step_counter/core/services/location_service.dart';
import 'package:step_counter/features/weather/data/models/location_params.dart';
import 'package:step_counter/features/weather/domain/usecases/get_current_weather.dart';
import 'package:workmanager/workmanager.dart';
import 'notification_service.dart';

class BackgroundService {
  static const String weatherTaskName = 'weather_background_task';

  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);

    await Workmanager().registerPeriodicTask(
      weatherTaskName,
      weatherTaskName,
      frequency: const Duration(minutes: 30),
    );
  }

  static Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case BackgroundService.weatherTaskName:
        try {
          await setupDependencies();

          final locationService = getIt<LocationService>();
          final getCurrentWeather = getIt<GetCurrentWeather>();

          final position = await locationService.getCurrentPosition();
          final locationParams = LocationParams(
            lat: position.latitude,
            lon: position.longitude,
          );

          final result = await getCurrentWeather(locationParams);

          result.fold(
            (failure) async {
              await NotificationService.showWeatherNotification(
                'Weather Update',
                'Failed to fetch weather data',
              );
            },
            (weather) async {
              await NotificationService.showWeatherNotification(
                'Weather Update',
                'Current temperature: ${weather.temperature.round()}°C, ${weather.description}',
              );
            },
          );
        } catch (e) {
          await NotificationService.showWeatherNotification(
            'Weather Update',
            'Error: ${e.toString()}',
          );
        }

        break;
    }
    return Future.value(true);
  });
}
