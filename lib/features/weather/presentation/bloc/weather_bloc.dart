import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_counter/features/weather/data/models/location_params.dart';
import 'package:step_counter/features/weather/presentation/bloc/eather_event.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../domain/usecases/get_weather_forecast.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeather getCurrentWeather;
  final GetWeatherForecast getWeatherForecast;
  final LocationService locationService;

  Timer? _refreshTimer;

  WeatherBloc({
    required this.getCurrentWeather,
    required this.getWeatherForecast,
    required this.locationService,
  }) : super(WeatherInitial()) {
    on<GetWeatherEvent>(_onGetWeather);
    on<RefreshWeatherEvent>(_onRefreshWeather);

    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(minutes: 30),
      (timer) => add(RefreshWeatherEvent()),
    );
  }

  Future<void> _onGetWeather(
    GetWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());

    try {
      double lat, lon;

      if (event.lat != null && event.lon != null) {
        lat = event.lat!;
        lon = event.lon!;
      } else {
        final position = await locationService.getCurrentPosition();
        lat = position.latitude;
        lon = position.longitude;
      }

      final locationParams = LocationParams(lat: lat, lon: lon);

      final currentWeatherResult = await getCurrentWeather(locationParams);
      final forecastResult = await getWeatherForecast(locationParams);

      currentWeatherResult.fold(
        (failure) => emit(WeatherError(failure.toString())),
        (currentWeather) {
          forecastResult.fold(
            (failure) => emit(WeatherError(failure.toString())),
            (forecast) => emit(
              WeatherLoaded(currentWeather: currentWeather, forecast: forecast),
            ),
          );
        },
      );
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }

  Future<void> _onRefreshWeather(
    RefreshWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    add(const GetWeatherEvent());
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}
