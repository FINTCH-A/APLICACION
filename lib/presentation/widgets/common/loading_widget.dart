import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool fullScreen;

  const LoadingWidget({super.key, this.message, this.fullScreen = false});

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );

    if (fullScreen) {
      return Scaffold(backgroundColor: AppColors.background, body: content);
    }

    return content;
  }
}
