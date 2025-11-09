import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

/// Condition selector widget for book posting
class ConditionSelector extends StatelessWidget {
  final String selectedCondition;
  final Function(String) onConditionSelected;

  const ConditionSelector({
    super.key,
    required this.selectedCondition,
    required this.onConditionSelected,
  });

  static const List<String> conditions = [
    AppStrings.conditionNew,
    AppStrings.conditionLikeNew,
    AppStrings.conditionGood,
    AppStrings.conditionUsed,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.condition,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: conditions.map((condition) {
            final isSelected = condition == selectedCondition;
            return ChoiceChip(
              label: Text(condition),
              selected: isSelected,
              onSelected: (_) => onConditionSelected(condition),
              selectedColor: AppColors.secondary,
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.secondary : Colors.grey[300]!,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}