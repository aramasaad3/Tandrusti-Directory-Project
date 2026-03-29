import 'package:flutter/material.dart';
import '../main.dart';
import '../services/localization_service.dart';

class DoctorCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String lang;
  final bool isOpen;

  const DoctorCard({
    super.key,
    required this.data,
    required this.lang,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    final doctorName = data['name'] ?? 'Unknown Doctor';
    String rawSpecialty = data['specialty'] ?? 'Specialty Unknown';
    String rawCity = data['city'] ?? 'Erbil';
    
    final doctorSpecialty = LocalizationService.translate(rawSpecialty, lang);
    final doctorCity = LocalizationService.translate(rawCity, lang);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderTertiary),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.accentGreenSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.person, color: AppColors.accentGreen),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctorName, 
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)
                ),
                SizedBox(height: 4),
                Text(
                  doctorSpecialty, 
                  style: TextStyle(color: AppColors.accentGreen, fontSize: 13, fontWeight: FontWeight.w600)
                ),
                SizedBox(height: 4),
                Row(
                   children: [
                     Icon(Icons.location_on, size: 12, color: AppColors.textSecondary),
                     SizedBox(width: 4),
                      Text(doctorCity, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                   ],
                )
              ],
            ),
          ),
          Container(
             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
             decoration: BoxDecoration(
                color: isOpen ? AppColors.accentGreenSoft : AppColors.redSoft,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isOpen ? AppColors.accentGreen.withOpacity(0.3) : AppColors.red.withOpacity(0.3)
                )
             ),
             child: Text(
                isOpen ? LocalizationService.translate('open', lang) : LocalizationService.translate('closed', lang),
                style: TextStyle(
                   color: isOpen ? AppColors.accentGreen : AppColors.red,
                   fontSize: 11,
                   fontWeight: FontWeight.bold
                ),
             )
          )
        ],
      ),
    );
  }
}
