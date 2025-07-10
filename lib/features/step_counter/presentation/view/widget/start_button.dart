import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_counter/core/locale/app_locale_key.dart';
import 'package:step_counter/core/theme/app_colors.dart';
import 'package:step_counter/features/step_counter/presentation/bloc/step_counter_bloc.dart';
import 'package:step_counter/features/step_counter/presentation/bloc/step_counter_event.dart';
import 'package:step_counter/features/step_counter/presentation/bloc/step_counter_state.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StepCounterBloc, StepCounterState>(
      builder: (context, state) {
        final isTracking = state is StepCounterLoaded && state.data.isTracking;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: isTracking
                  ? [AppColors.lightRed, AppColors.darkRed]
                  : [AppColors.lightBlue, AppColors.darkBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: isTracking ? AppColors.redShadow : AppColors.blueShadow,
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              if (isTracking) {
                context.read<StepCounterBloc>().add(StopTrackingEvent());
              } else {
                context.read<StepCounterBloc>().add(StartTrackingEvent());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isTracking ? Icons.stop : Icons.play_arrow,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  isTracking ? AppLocaleKey.stop : AppLocaleKey.start,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
