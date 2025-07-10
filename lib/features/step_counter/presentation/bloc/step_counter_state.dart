import 'package:equatable/equatable.dart';
import 'package:step_counter/features/step_counter/domain/entities/step_counter_data.dart';

abstract class StepCounterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StepCounterInitial extends StepCounterState {}

class StepCounterLoading extends StepCounterState {}

class StepCounterLoaded extends StepCounterState {
  final StepCounterData data;

  StepCounterLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class StepCounterError extends StepCounterState {
  final String message;

  StepCounterError(this.message);

  @override
  List<Object?> get props => [message];
}
