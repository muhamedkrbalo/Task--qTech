import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:step_counter/core/locale/app_locale_key.dart';
import 'package:step_counter/features/custom_widget/custom_network_image.dart';
import 'package:step_counter/features/weather/domain/entities/weather.dart';

class ForecastSliverList extends StatelessWidget {
  final WeatherForecast forecast;

  const ForecastSliverList({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Map<String, Weather> dailyForecasts = {};
    for (var weather in forecast.dailyWeather) {
      final dateKey = DateFormat('yyyy-MM-dd').format(weather.dateTime);
      if (!dailyForecasts.containsKey(dateKey)) {
        dailyForecasts[dateKey] = weather;
      }
    }

    final List<Weather> uniqueDays = dailyForecasts.values.toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppLocaleKey.thisWeek,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }

          final weather = uniqueDays[index - 1];
          final isToday =
              DateFormat('yyyy-MM-dd').format(weather.dateTime) ==
              DateFormat('yyyy-MM-dd').format(DateTime.now());

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CustomNetworkImage(
                imageUrl:
                    'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
                width: 50,
                height: 50,
              ),
              title: Text(
                isToday
                    ? AppLocaleKey.today
                    : DateFormat('EEEE').format(weather.dateTime),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                weather.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${weather.temperature.round()}°C',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${weather.humidity.round()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount:
            1 + uniqueDays.length.clamp(0, 7), // 1 for title + forecast items
      ),
    );
  }
}
