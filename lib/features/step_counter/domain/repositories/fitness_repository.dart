import '../entities/step_counter_data.dart';

abstract class StepCounterRepository {
  Future<void> startTracking();
  Future<void> stopTracking();
  Future<StepCounterData> getStepCounterData();
  Stream<int> getStepStream();
}
