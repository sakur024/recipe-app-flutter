import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  int selectedIndex = 0;

  static const categories = [
    'All',
    'Dinner',
    'Lunch',
    'Breakfast',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Categories',
          style: AppTextStyles.title,
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              categories.length,
              (index) {
                final selected = selectedIndex == index;

                return Padding(
                  padding: EdgeInsets.only(
                    right: index == categories.length - 1 ? 0 : 10,
                  ),
                  child: ChoiceChip(
                    label: Text(categories[index]),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: selected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primary,
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}