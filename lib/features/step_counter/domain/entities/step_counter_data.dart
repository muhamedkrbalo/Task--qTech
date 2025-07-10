import 'package:equatable/equatable.dart';

class StepCounterData extends Equatable {
  final int steps;
  final double distance;
  final DateTime timestamp;
  final bool isTracking;

  const StepCounterData({
    required this.steps,
    required this.distance,
    required this.timestamp,
    required this.isTracking,
  });

  @override
  List<Object?> get props => [steps, distance, timestamp, isTracking];
}
