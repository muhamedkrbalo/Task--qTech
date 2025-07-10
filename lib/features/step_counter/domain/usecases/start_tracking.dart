import 'package:step_counter/features/step_counter/domain/repositories/fitness_repository.dart';

class StartTracking {
  final StepCounterRepository repository;

  StartTracking(this.repository);

  Future<void> call() async {
    return await repository.startTracking();
  }
}
