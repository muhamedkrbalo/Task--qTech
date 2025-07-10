import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:step_counter/core/constants/constants.dart';
import 'package:step_counter/core/network/api_consumer.dart';
import 'package:step_counter/core/network/app_interceptors.dart';
import 'package:step_counter/core/network/dio_consumer.dart';
import 'package:step_counter/core/services/location_service.dart';
import 'package:step_counter/core/services/step_counter_service.dart';
import 'package:step_counter/features/step_counter/data/datasources/step_counter_local_datasource.dart';
import 'package:step_counter/features/step_counter/data/repositories/fitness_repository_impl.dart';
import 'package:step_counter/features/step_counter/domain/repositories/fitness_repository.dart';
import 'package:step_counter/features/step_counter/domain/usecases/get_fitness_data.dart';
import 'package:step_counter/features/step_counter/domain/usecases/start_tracking.dart';
import 'package:step_counter/features/step_counter/domain/usecases/stop_tracking.dart';
import 'package:step_counter/features/step_counter/presentation/bloc/step_counter_bloc.dart';
import 'package:step_counter/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:step_counter/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:step_counter/features/weather/domain/repositories/weather_repository.dart';
import 'package:step_counter/features/weather/domain/usecases/get_current_weather.dart';
import 'package:step_counter/features/weather/domain/usecases/get_weather_forecast.dart';
import 'package:step_counter/features/weather/presentation/bloc/weather_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  final stepBox = await Hive.openBox('stepBox');

  getIt.registerSingleton<StepCounterLocalDataSource>(
    StepCounterLocalDataSourceImpl(stepBox),
  );

  getIt.registerSingleton<StepCounterService>(
    StepCounterService(getIt<StepCounterLocalDataSource>()),
  );

  getIt.registerSingleton<StepCounterRepository>(
    StepCounterRepositoryImpl(
      localDataSource: getIt<StepCounterLocalDataSource>(),
      stepCounterService: getIt<StepCounterService>(),
    ),
  );

  getIt.registerSingleton<StartTracking>(
    StartTracking(getIt<StepCounterRepository>()),
  );
  getIt.registerSingleton<StopTracking>(
    StopTracking(getIt<StepCounterRepository>()),
  );
  getIt.registerSingleton<GetStepCounterData>(
    GetStepCounterData(getIt<StepCounterRepository>()),
  );

  getIt.registerFactory(
    () => StepCounterBloc(
      startTracking: getIt(),
      stopTracking: getIt(),
      getStepCounterData: getIt(),
      stepCounterRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: getIt()));
  getIt.registerLazySingleton<AppInterceptors>(() => AppInterceptors());

  getIt.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton(() => GetCurrentWeather(getIt()));
  getIt.registerLazySingleton(() => GetWeatherForecast(getIt()));

  getIt.registerLazySingleton<LocationService>(() => LocationService());

  getIt.registerFactory(
    () => WeatherBloc(
      getCurrentWeather: getIt(),
      getWeatherForecast: getIt(),
      locationService: getIt(),
    ),
  );
}
