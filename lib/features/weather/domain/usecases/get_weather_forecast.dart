import 'package:dartz/dartz.dart';
import 'package:step_counter/core/error/failures.dart';
import 'package:step_counter/core/use_case/use_case.dart';
import 'package:step_counter/features/weather/data/models/location_params.dart';

import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetWeatherForecast implements UseCase<WeatherForecast, LocationParams> {
  final WeatherRepository repository;

  GetWeatherForecast(this.repository);

  @override
  Future<Either<Failure, WeatherForecast>> call(LocationParams params) {
    return repository.getWeatherForecast(params);
  }
}
