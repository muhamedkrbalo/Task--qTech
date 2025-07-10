import 'package:dartz/dartz.dart';
import 'package:step_counter/core/error/failures.dart';
import 'package:step_counter/core/use_case/use_case.dart';
import 'package:step_counter/features/weather/data/models/location_params.dart';
import 'package:step_counter/features/weather/domain/entities/weather.dart';
import 'package:step_counter/features/weather/domain/repositories/weather_repository.dart';

class GetCurrentWeather implements UseCase<Weather, LocationParams> {
  final WeatherRepository repository;

  GetCurrentWeather(this.repository);

  @override
  Future<Either<Failure, Weather>> call(LocationParams params) {
    return repository.getCurrentWeather(params);
  }
}
