import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:step_counter/features/step_counter/data/datasources/step_counter_local_datasource.dart';

class StepCounterService {
  static const double _stepThreshold = 10.0;
  static const int _minStepInterval = 300;

  final StepCounterLocalDataSource localDataSource;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  int _stepCount = 0;
  bool _isTracking = false;
  double _previousMagnitude = 0.0;
  DateTime? _lastStepTime;

  final StreamController<int> _stepController =
      StreamController<int>.broadcast();
  Stream<int> get stepStream => _stepController.stream;

  StepCounterService(this.localDataSource);

  Future<void> initialize() async {
    try {
      _stepCount = localDataSource.getStepCount();
      _isTracking = localDataSource.getTrackingState();

      _stepController.add(_stepCount);

      if (_isTracking) {
        _startListening();
      }
    } catch (e) {
      print('Error initializing StepCounterService: $e');
    }
  }

  Future<void> startTracking() async {
    if (_isTracking) return;

    _isTracking = true;
    await localDataSource.saveTrackingState(true);
    _startListening();

    _stepController.add(_stepCount);
  }

  Future<void> stopTracking() async {
    if (!_isTracking) return;

    _isTracking = false;
    await localDataSource.saveTrackingState(false);
    _stopListening();
  }

  void _startListening() {
    _accelerometerSubscription?.cancel();

    _accelerometerSubscription = accelerometerEvents.listen(
      (AccelerometerEvent event) {
        if (!_isTracking) return;

        final magnitude = _calculateMagnitude(event.x, event.y, event.z);
        final now = DateTime.now();

        if (_lastStepTime == null ||
            now.difference(_lastStepTime!).inMilliseconds > _minStepInterval) {
          if (_previousMagnitude > 0 && magnitude > _stepThreshold) {
            final diff = magnitude - _previousMagnitude;
            if (diff > 2.0) {
              _stepCount++;
              _lastStepTime = now;
              _saveStepCount();
              _stepController.add(_stepCount);
            }
          }
        }

        _previousMagnitude = magnitude;
      },
      onError: (error) {
        print('Accelerometer error: $error');
      },
    );
  }

  void _stopListening() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
  }

  double _calculateMagnitude(double x, double y, double z) {
    return (x * x + y * y + z * z);
  }

  Future<void> _saveStepCount() async {
    try {
      await localDataSource.saveStepCount(_stepCount);
    } catch (e) {}
  }

  int get stepCount => _stepCount;
  bool get isTracking => _isTracking;

  void dispose() {
    _stopListening();
    _stepController.close();
  }
}
