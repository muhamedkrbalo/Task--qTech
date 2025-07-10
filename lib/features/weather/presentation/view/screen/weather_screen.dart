import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_counter/core/service_locator/service_locator.dart';
import 'package:step_counter/features/custom_widget/error_widget.dart';
import 'package:step_counter/features/weather/presentation/bloc/eather_event.dart';
import 'package:step_counter/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:step_counter/features/weather/presentation/bloc/weather_state.dart';
import 'package:step_counter/features/weather/presentation/view/widget/forecast_list.dart';
import 'package:step_counter/features/weather/presentation/view/widget/weather_card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          getIt<WeatherBloc>()..add(const GetWeatherEvent()),
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<WeatherBloc>().add(RefreshWeatherEvent());
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: WeatherCard(weather: state.currentWeather),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: ForecastSliverList(forecast: state.forecast),
                  ),
                ],
              ),
            );
          } else if (state is WeatherError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<WeatherBloc>().add(const GetWeatherEvent());
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
