import 'package:step_counter/features/step_counter/domain/repositories/fitness_repository.dart';

import '../entities/step_counter_data.dart';

class GetStepCounterData {
  final StepCounterRepository repository;

  GetStepCounterData(this.repository);

  Future<StepCounterData> call() async {
    return await repository.getStepCounterData();
  }
}
