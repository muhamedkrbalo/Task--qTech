import 'package:step_counter/features/weather/domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.cityName,
    required super.temperature,
    required super.description,
    required super.icon,
    required super.humidity,
    required super.windSpeed,
    required super.feelsLike,
    required super.dateTime,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      humidity: (json['main']['humidity'] as num).toDouble(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }
}

class WeatherForecastModel extends WeatherForecast {
  const WeatherForecastModel({required super.dailyWeather});

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    final List<Weather> dailyWeather = [];

    for (var item in json['list']) {
      dailyWeather.add(WeatherModel.fromJson(item));
    }

    return WeatherForecastModel(dailyWeather: dailyWeather);
  }
}
