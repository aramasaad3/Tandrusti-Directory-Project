import 'package:flutter/material.dart';
import '../main.dart';
import '../services/localization_service.dart';

class DoctorCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String lang;

  const DoctorCard({
    super.key,
    required this.data,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final String baseName = data['name'] ?? 'Unknown Doctor';
    final String kName = data['nameKu'] ?? '';
    final doctorName = (lang == 'Kurdish' && kName.isNotEmpty) ? kName : baseName;
    String rawSpecialty = data['specialty'] ?? 'Specialty Unknown';
    String rawCity = data['city'] ?? 'Erbil';
    
    final doctorSpecialty = LocalizationService.translate(rawSpecialty, lang);
    final doctorCity = LocalizationService.translate(rawCity, lang);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctorName, 
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)
                ),
                const SizedBox(height: 4),
                Text(
                  doctorSpecialty, 
                  style: TextStyle(color: AppColors.accentGreen, fontSize: 13, fontWeight: FontWeight.w600)
                ),
                const SizedBox(height: 4),
                Row(
                   children: [
                     Icon(Icons.location_on, size: 12, color: AppColors.textSecondary),
                     const SizedBox(width: 4),
                      Text(doctorCity, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                   ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
