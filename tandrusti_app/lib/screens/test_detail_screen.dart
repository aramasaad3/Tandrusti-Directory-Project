import 'package:flutter/material.dart';
import '../main.dart';
import '../services/app_state.dart';
import '../services/localization_service.dart';

class TestDetailScreen extends StatelessWidget {
  final String testId;
  final Map<String, dynamic> testData;
  final Color iconColor;

  const TestDetailScreen({
    super.key, 
    required this.testId, 
    required this.testData,
    required this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final lang = AppState.instance.language;

        // Helper: pick Kurdish field if available, else English
        String field(String key, String fallback) {
          if (lang == 'Kurdish') {
            final kuVal = testData['${key}_ku'];
            if (kuVal != null && kuVal.toString().isNotEmpty) return kuVal.toString();
          }
          return (testData[key] ?? fallback).toString();
        }

        final testName = field('testName', 'Unknown Test');
        final category = field('category', 'Diagnostic');
        final duration = field('duration', '15-30 min');
        final whatToExpect = field('whatToExpect', 'No information provided.');
        
        // Translate fallback strings when needed
        final whatToExpectDisplay = LocalizationService.translate(whatToExpect, lang);
        final categoryDisplay = LocalizationService.translate(category, lang);
        
        final prepStr = field('preparationInstruction', '');
        List<String> steps = prepStr.split('.').where((s) => s.trim().length > 5).map((s) => LocalizationService.translate(s.trim(), lang)).toList();
        if (steps.isEmpty) {
          steps = [LocalizationService.translate('No specific preparation needed.', lang)];
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              // Orange Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
                decoration: BoxDecoration(
                  color: AppColors.amber,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32)
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(12),
                       decoration: BoxDecoration(
                         color: AppColors.white.withValues(alpha: 0.2),
                         borderRadius: BorderRadius.circular(16)
                       ),
                      child: Icon(Icons.biotech, color: AppColors.white, size: 32)
                    ),
                    const SizedBox(height: 16),
                    Text(
                      testName, 
                      style: TextStyle(color: AppColors.white, fontSize: 28, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$categoryDisplay · $duration', 
                      style: TextStyle(color: AppColors.white.withValues(alpha: 0.8), fontSize: 16)
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(LocalizationService.translate('what_is_it', lang).toUpperCase(), style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
                       const SizedBox(height: 12),
                       Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.borderTertiary),
                        ),
                        child: Text(
                          whatToExpectDisplay,
                          style: TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.5),
                        ),
                      ),

                      const SizedBox(height: 32),
                      
                      Text(LocalizationService.translate('prep_steps', lang).toUpperCase(), style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      
                      Column(
                        children: steps.asMap().entries.map((entry) {
                          int idx = entry.key;
                          String val = entry.value.trim();
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: AppColors.amberSoft,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${idx + 1}',
                                      style: TextStyle(
                                        color: AppColors.amber,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      val,
                                      style: TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
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
}
