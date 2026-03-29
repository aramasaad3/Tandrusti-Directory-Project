import 'package:flutter/material.dart';
import '../main.dart';

class FilterIconButton extends StatelessWidget {
  final VoidCallback onTap;

  const FilterIconButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52, // Match textfield height
        width: 52,
        decoration: BoxDecoration(
          color: AppColors.filterInactive,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accentGreenSoft),
        ),
        child: Icon(Icons.tune, color: AppColors.accentGreen, size: 24),
      ),
    );
  }
}
