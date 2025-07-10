import 'package:dartz/dartz.dart';
import 'package:step_counter/core/error/failures.dart';
import 'package:step_counter/core/network/handle_dio_request.dart';
import 'package:step_counter/features/weather/data/models/location_params.dart';

import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_datasource.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Weather>> getCurrentWeather(LocationParams params) {
    return handleDioRequest(
      request: () async => await remoteDataSource.getCurrentWeather(params),
    );
  }

  @override
  Future<Either<Failure, WeatherForecast>> getWeatherForecast(
    LocationParams params,
  ) async {
    return handleDioRequest(
      request: () async => await remoteDataSource.getWeatherForecast(params),
    );
  }
}
