import 'package:flutter/material.dart';
import 'package:step_counter/core/locale/app_locale_key.dart';
import 'package:step_counter/core/theme/app_colors.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final void Function() onRetry;
  const CustomErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.lightRed),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text(AppLocaleKey.retry),
          ),
        ],
      ),
    );
  }
}
