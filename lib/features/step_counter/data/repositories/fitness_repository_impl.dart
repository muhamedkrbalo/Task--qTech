import 'package:step_counter/core/services/step_counter_service.dart';
import 'package:step_counter/features/step_counter/data/datasources/step_counter_local_datasource.dart';
import 'package:step_counter/features/step_counter/domain/repositories/fitness_repository.dart';

import '../../domain/entities/step_counter_data.dart';

class StepCounterRepositoryImpl implements StepCounterRepository {
  final StepCounterLocalDataSource localDataSource;
  final StepCounterService stepCounterService;

  StepCounterRepositoryImpl({
    required this.localDataSource,
    required this.stepCounterService,
  });

  @override
  Future<void> startTracking() async {
    await stepCounterService.initialize();
    await stepCounterService.startTracking();
  }

  @override
  Future<void> stopTracking() async {
    await stepCounterService.stopTracking();
  }

  @override
  Future<StepCounterData> getStepCounterData() async {
    await stepCounterService.initialize();
    final steps = stepCounterService.stepCount;
    final distance = steps * 0.8;

    return StepCounterData(
      steps: steps,
      distance: distance,
      timestamp: DateTime.now(),
      isTracking: stepCounterService.isTracking,
    );
  }

  @override
  Stream<int> getStepStream() {
    return stepCounterService.stepStream;
  }
}
