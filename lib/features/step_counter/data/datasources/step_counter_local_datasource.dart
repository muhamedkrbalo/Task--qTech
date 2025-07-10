import 'package:hive/hive.dart';
import 'package:step_counter/core/constants/constants.dart';

abstract class StepCounterLocalDataSource {
  Future<void> saveStepCount(int steps);
  int getStepCount();
  Future<void> saveTrackingState(bool isTracking);
  bool getTrackingState();
}

class StepCounterLocalDataSourceImpl implements StepCounterLocalDataSource {
  final Box box;

  StepCounterLocalDataSourceImpl(this.box);

  @override
  Future<void> saveStepCount(int steps) async {
    await box.put(Constants.stepCountKey, steps);
  }

  @override
  int getStepCount() {
    return box.get(Constants.stepCountKey, defaultValue: 0);
  }

  @override
  Future<void> saveTrackingState(bool isTracking) async {
    await box.put(Constants.isTrackingKey, isTracking);
  }

  @override
  bool getTrackingState() {
    return box.get(Constants.isTrackingKey, defaultValue: false);
  }
}
