import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Text(
            'What are you\ncooking today?',
            style: AppTextStyles.heading,
          ),
        ),
        Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.all(13),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 23,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}