import 'package:equatable/equatable.dart';

abstract class StepCounterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartTrackingEvent extends StepCounterEvent {}

class StopTrackingEvent extends StepCounterEvent {}

class GetStepCounterDataEvent extends StepCounterEvent {}

class StepCountUpdatedEvent extends StepCounterEvent {
  final int steps;
  StepCountUpdatedEvent(this.steps);

  @override
  List<Object?> get props => [steps];
}
