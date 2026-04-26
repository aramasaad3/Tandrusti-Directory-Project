import 'package:flutter/material.dart';
import '../main.dart';
import '../services/app_state.dart';
import '../services/localization_service.dart';

class MedicineDetailScreen extends StatelessWidget {
  final String medicineId;
  final Map<String, dynamic> medicineData;

  const MedicineDetailScreen({
    super.key, 
    required this.medicineId, 
    required this.medicineData
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final lang = AppState.instance.language;
        final isFav = AppState.instance.isMedFavorite(medicineId);

        // Helper: pick Kurdish field if available, else English
        String field(String key, String fallback) {
          if (lang == 'Kurdish') {
            final kuVal = medicineData['${key}_ku'];
            if (kuVal != null && kuVal.toString().isNotEmpty) return kuVal.toString();
          }
          return (medicineData[key] ?? fallback).toString();
        }

        final scientificName = medicineData['scientificName'] ?? 'Unknown Medicine';
        final brandsData = lang == 'Kurdish' && medicineData['commonBrands_ku'] != null
            ? medicineData['commonBrands_ku']
            : medicineData['commonBrands'];
        final brands = (brandsData is List) ? brandsData.join(', ') : LocalizationService.translate('No Brands available', lang);
        final category = field('category', 'Medicine');
        final translatedCategory = LocalizationService.translate(category, lang);
        
        final uses = field('usageInstructions', 'No usage data');
        final dosage = field('dosage', 'Refer to doctor');
        final sideEffects = field('sideEffects', 'None recorded');
        final contraindications = field('contraindications', 'None recorded');
        
        // Translate all content fallback strings to Kurdish
        final usesDisplay = LocalizationService.translate(uses, lang);
        final dosageDisplay = LocalizationService.translate(dosage, lang);
        final sideEffectsDisplay = LocalizationService.translate(sideEffects, lang);
        final contraindicationsDisplay = LocalizationService.translate(contraindications, lang);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              // Green Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32)
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_back_ios, color: AppColors.white, size: 14),
                                const SizedBox(width: 4),
                                Text(LocalizationService.translate('back', lang), style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => AppState.instance.toggleFavoriteMedicine(medicineId),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isFav ? AppColors.redSoft : AppColors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? AppColors.red : AppColors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text('💊', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 16),
                    Text(
                      scientificName, 
                      style: TextStyle(color: AppColors.white, fontSize: 28, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$brands · $translatedCategory', 
                      style: TextStyle(color: AppColors.white.withValues(alpha: 0.8), fontSize: 16)
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildInfoCard(
                        icon: Icons.check,
                        iconColor: AppColors.accentGreen,
                        bgColor: AppColors.accentGreenSoft,
                        title: LocalizationService.translate('uses', lang).toUpperCase(),
                        content: usesDisplay,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        icon: Icons.info_outline,
                        iconColor: AppColors.blue,
                        bgColor: AppColors.blueSoft,
                        title: LocalizationService.translate('dosage_info', lang).toUpperCase(),
                        content: dosageDisplay,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        icon: Icons.warning_amber_rounded,
                        iconColor: AppColors.amber,
                        bgColor: AppColors.amberSoft,
                        title: LocalizationService.translate('side_effects', lang).toUpperCase(),
                        content: sideEffectsDisplay,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        icon: Icons.close,
                        iconColor: AppColors.red,
                        bgColor: AppColors.redSoft,
                        title: LocalizationService.translate('contraindications', lang).toUpperCase(),
                        content: contraindicationsDisplay,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard({
    required IconData icon, 
    required Color iconColor, 
    required Color bgColor,
    required String title, 
    required String content
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderTertiary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
