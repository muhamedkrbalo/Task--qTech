import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_counter/core/locale/app_locale_key.dart';
import 'package:step_counter/core/service_locator/service_locator.dart';
import 'package:step_counter/core/theme/app_colors.dart';
import 'package:step_counter/features/custom_widget/error_widget.dart';
import 'package:step_counter/features/step_counter/presentation/bloc/step_counter_bloc.dart';
import 'package:step_counter/features/step_counter/presentation/bloc/step_counter_event.dart';
import 'package:step_counter/features/step_counter/presentation/bloc/step_counter_state.dart';
import 'package:step_counter/features/step_counter/presentation/view/widget/animated_counter.dart';
import 'package:step_counter/features/step_counter/presentation/view/widget/start_button.dart';
import 'package:step_counter/features/step_counter/presentation/view/widget/step_counter_card.dart';

class StepCounterScreen extends StatelessWidget {
  const StepCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          getIt<StepCounterBloc>()..add(GetStepCounterDataEvent()),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StartButton(),
            const SizedBox(height: 20),
            BlocBuilder<StepCounterBloc, StepCounterState>(
              builder: (context, state) {
                if (state is StepCounterLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is StepCounterLoaded) {
                  return Column(
                    children: [
                      StepCounterCard(
                        title: AppLocaleKey.steps,
                        value: state.data.steps.toString(),
                        subtitle: AppLocaleKey.today,
                        icon: Icons.directions_walk,
                        child: AnimatedCounter(
                          value: state.data.steps,
                          duration: const Duration(milliseconds: 500),
                        ),
                      ),
                      const SizedBox(height: 16),
                      StepCounterCard(
                        title: AppLocaleKey.distance,
                        value:
                            '${(state.data.distance / 1000).toStringAsFixed(1)} ${AppLocaleKey.km}',
                        subtitle: AppLocaleKey.today,
                        icon: Icons.social_distance,
                      ),
                    ],
                  );
                } else if (state is StepCounterError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () {
                      context.read<StepCounterBloc>().add(
                        GetStepCounterDataEvent(),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
