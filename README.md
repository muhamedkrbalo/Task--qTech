
#  Step Counter & Weather App

A simple Flutter app that tracks the number of steps using the phone's accelerometer and shows live weather updates.

## 💡 Features
- Start button to begin step tracking.
- Real-time step counter.
- Distance calculation (based on step count × 0.8 meters).
- Live weather updates with temperature.
- Daily forecast list.
- Weather notifications every 30 or 60 minutes, even if the app is closed or in background.

🛠️ Packages Used

Package Description

sensors_plus	Reads step-related data from the device’s accelerometer.

workmanager	Enables background/terminated tasks for scheduling periodic weather checks.

geolocator	Fetches the user’s location for accurate weather data.

flutter_local_notifications	Displays local notifications on the device.

cached_network_image Loads and caches network images efficiently.

dartz Provides functional programming features like Either, useful for clean error handling.

dio A powerful HTTP client for API communication.

equatable Helps with object comparison, especially in BLoC states.

flutter_bloc State management .

get_it A simple dependency injection tool.

hive Lightweight and fast local database .

pretty_dio_logger Logs HTTP requests/responses for debugging.

