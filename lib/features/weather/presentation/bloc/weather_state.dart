import 'package:equatable/equatable.dart';
import '../../domain/entities/weather.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather currentWeather;
  final WeatherForecast forecast;

  const WeatherLoaded({required this.currentWeather, required this.forecast});

  @override
  List<Object?> get props => [currentWeather, forecast];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object?> get props => [message];
}
