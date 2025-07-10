import 'package:step_counter/features/step_counter/domain/repositories/fitness_repository.dart';

class StopTracking {
  final StepCounterRepository repository;

  StopTracking(this.repository);

  Future<void> call() async {
    return await repository.stopTracking();
  }
}
