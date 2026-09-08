import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Top header for the Home screen.
///
/// Shows a greeting / title and a notification bell button.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.pagePadding,
      ),
      child: Row(
        children: [
          // ── Greeting ──────────────────────────────────────────────
          Expanded(
            child: Text(
              'What are you\ncooking today?',
              style: AppTextStyles.headingLarge,
            ),
          ),

          // ── Notification button ───────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              color: AppColors.textPrimary,
              onPressed: () {
                // TODO: navigate to notifications
              },
            ),
          ),
        ],
      ),
    );
  }
}
