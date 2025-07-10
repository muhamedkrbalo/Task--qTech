import 'package:step_counter/core/network/api_consumer.dart';
import 'package:step_counter/core/network/end_points.dart';
import 'package:step_counter/features/weather/data/models/location_params.dart';
import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(LocationParams params);
  Future<WeatherForecastModel> getWeatherForecast(LocationParams params);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final ApiConsumer dio;

  WeatherRemoteDataSourceImpl(this.dio);

  @override
  Future<WeatherModel> getCurrentWeather(LocationParams params) async {
    try {
      final response = await dio.get(
        EndPoints.weather,
        queryParameters: {
          ...params.toJson(),

          //! NOTE:  the API key should be stored securely in an .env file or similar.
          //! But I put it here temporarily so you can test and experiment.
          'appid': 'af95efc597856a0a2bc46c0ffe374119',
          'units': 'metric',
        },
      );

      return WeatherModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch current weather: $e');
    }
  }

  @override
  Future<WeatherForecastModel> getWeatherForecast(LocationParams params) async {
    try {
      final response = await dio.get(
        EndPoints.forecast,
        queryParameters: {
          ...params.toJson(),
          'appid': 'af95efc597856a0a2bc46c0ffe374119',
          'units': 'metric',
        },
      );

      return WeatherForecastModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch weather forecast: $e');
    }
  }
}
