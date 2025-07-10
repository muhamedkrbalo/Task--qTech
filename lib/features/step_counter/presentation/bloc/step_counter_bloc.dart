import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_counter/features/step_counter/domain/entities/step_counter_data.dart';
import 'package:step_counter/features/step_counter/domain/repositories/fitness_repository.dart';
import 'package:step_counter/features/step_counter/domain/usecases/get_fitness_data.dart';
import 'package:step_counter/features/step_counter/domain/usecases/start_tracking.dart';
import 'package:step_counter/features/step_counter/domain/usecases/stop_tracking.dart';
import 'package:step_counter/features/step_counter/presentation/bloc/step_counter_event.dart';
import 'package:step_counter/features/step_counter/presentation/bloc/step_counter_state.dart';

class StepCounterBloc extends Bloc<StepCounterEvent, StepCounterState> {
  final StartTracking startTracking;
  final StopTracking stopTracking;
  final GetStepCounterData getStepCounterData;
  final StepCounterRepository stepCounterRepository;

  StreamSubscription<int>? _stepStreamSubscription;

  StepCounterBloc({
    required this.startTracking,
    required this.stopTracking,
    required this.getStepCounterData,
    required this.stepCounterRepository,
  }) : super(StepCounterInitial()) {
    on<StartTrackingEvent>(_onStartTracking);
    on<StopTrackingEvent>(_onStopTracking);
    on<GetStepCounterDataEvent>(_onGetStepCounterData);
    on<StepCountUpdatedEvent>(_onStepCountUpdated);
  }

  void _onStartTracking(
    StartTrackingEvent event,
    Emitter<StepCounterState> emit,
  ) async {
    emit(StepCounterLoading());
    try {
      await startTracking.call();

      // بدء الاستماع للـ step stream
      _stepStreamSubscription?.cancel();
      _stepStreamSubscription = stepCounterRepository.getStepStream().listen((
        steps,
      ) {
        add(StepCountUpdatedEvent(steps));
      });

      add(GetStepCounterDataEvent());
    } catch (e) {
      emit(StepCounterError(e.toString()));
    }
  }

  void _onStopTracking(
    StopTrackingEvent event,
    Emitter<StepCounterState> emit,
  ) async {
    try {
      await stopTracking.call();

      // إيقاف الاستماع للـ step stream
      _stepStreamSubscription?.cancel();
      _stepStreamSubscription = null;

      add(GetStepCounterDataEvent());
    } catch (e) {
      emit(StepCounterError(e.toString()));
    }
  }

  void _onGetStepCounterData(
    GetStepCounterDataEvent event,
    Emitter<StepCounterState> emit,
  ) async {
    try {
      final data = await getStepCounterData.call();
      emit(StepCounterLoaded(data));
    } catch (e) {
      emit(StepCounterError(e.toString()));
    }
  }

  void _onStepCountUpdated(
    StepCountUpdatedEvent event,
    Emitter<StepCounterState> emit,
  ) {
    if (state is StepCounterLoaded) {
      final currentData = (state as StepCounterLoaded).data;
      final distance = event.steps * 0.8;
      final updatedData = StepCounterData(
        steps: event.steps,
        distance: distance,
        timestamp: DateTime.now(),
        isTracking: currentData.isTracking,
      );
      emit(StepCounterLoaded(updatedData));
    }
  }

  @override
  Future<void> close() {
    _stepStreamSubscription?.cancel();
    return super.close();
  }
}
