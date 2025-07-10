import 'package:dartz/dartz.dart';
import 'package:step_counter/core/error/failures.dart';
import 'package:step_counter/features/weather/data/models/location_params.dart';

import '../entities/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getCurrentWeather(LocationParams params);
  Future<Either<Failure, WeatherForecast>> getWeatherForecast(
    LocationParams params,
  );
}
