import 'package:flutter/material.dart';
import '../main.dart';
import '../services/localization_service.dart';

class FilterBottomSheet extends StatefulWidget {
  final String currentCity;
  final String currentSpecialty;
  final String lang;
  final Function(String, String) onApply;

  const FilterBottomSheet({
    super.key, 
    required this.currentCity, 
    required this.currentSpecialty,
    required this.lang,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _tempCity;
  late String _tempSpecialty;

  final List<String> _cities = ['All Cities', 'Erbil', 'Suleimani', 'Duhok', 'Kirkuk'];
  final List<String> _specialties = [
    'All Specialties', 'Cardiologist', 'Dermatologist', 'Neurologist', 'Pediatrician', 'Dentist'
  ];

  @override
  void initState() {
    super.initState();
    _tempCity = widget.currentCity;
    _tempSpecialty = widget.currentSpecialty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 30),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            LocalizationService.translate('specialty', widget.lang).toUpperCase(),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _specialties.map((s) => _buildChip(
              label: LocalizationService.translate(s, widget.lang),
              isSelected: _tempSpecialty == s,
              onTap: () => setState(() => _tempSpecialty = s),
            )).toList(),
          ),
          const SizedBox(height: 24),
          Text(
            LocalizationService.translate('location', widget.lang).toUpperCase(),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _cities.map((c) => _buildChip(
              label: LocalizationService.translate(c, widget.lang),
              isSelected: _tempCity == c,
              onTap: () => setState(() => _tempCity = c),
            )).toList(),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onApply(_tempCity, _tempSpecialty);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                LocalizationService.translate('back', widget.lang), // Using back or add new key? Wait, let's use a clear button name.
                style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentGreenSoft : AppColors.filterInactive,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.accentGreen : AppColors.borderTertiary),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.accentGreen : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
