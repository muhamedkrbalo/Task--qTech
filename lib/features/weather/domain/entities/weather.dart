import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final double humidity;
  final double windSpeed;
  final double feelsLike;
  final DateTime dateTime;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [
    cityName,
    temperature,
    description,
    icon,
    humidity,
    windSpeed,
    feelsLike,
    dateTime,
  ];
}

class WeatherForecast extends Equatable {
  final List<Weather> dailyWeather;

  const WeatherForecast({required this.dailyWeather});

  @override
  List<Object?> get props => [dailyWeather];
}
