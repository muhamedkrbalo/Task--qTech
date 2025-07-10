import 'package:flutter/material.dart';
import 'package:step_counter/core/locale/app_locale_key.dart';
import 'package:step_counter/features/step_counter/presentation/view/screen/step_counter_screen.dart';
import 'package:step_counter/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:step_counter/features/weather/presentation/view/screen/weather_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppLocaleKey.tasks),

        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: AppLocaleKey.overview),
            Tab(text: AppLocaleKey.weather),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [StepCounterScreen(), WeatherScreen()],
      ),
    );
  }
}
