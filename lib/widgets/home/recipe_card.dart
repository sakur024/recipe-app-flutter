import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/recipe.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: AspectRatio(
                  aspectRatio: 1.15,
                  child: Image.network(
                    recipe.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        color: AppColors.primaryLight,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.restaurant,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(7),
                      child: Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            recipe.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.subtitle,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.bolt,
                size: 14,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 3),
              Text(
                '${recipe.calories} Cal',
                style: AppTextStyles.small,
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.access_time,
                size: 14,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 3),
              Text(
                '${recipe.timeMinutes} Min',
                style: AppTextStyles.small,
              ),
            ],
          ),
        ],
      ),
    );
  }
}