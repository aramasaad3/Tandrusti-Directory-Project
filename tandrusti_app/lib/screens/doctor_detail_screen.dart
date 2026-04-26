import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../services/app_state.dart';
import '../services/localization_service.dart';
import '../services/map_service.dart';

class DoctorDetailScreen extends StatelessWidget {
  final String doctorId;
  final Map<String, dynamic> doctorData;

  const DoctorDetailScreen({super.key, required this.doctorId, required this.doctorData});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final lang = AppState.instance.language;
        final isFav = AppState.instance.isDocFavorite(doctorId);

        final String baseName = doctorData['name'] ?? 'Unknown Doctor';
        final String kName = doctorData['nameKu'] ?? '';
        final doctorName = (lang == 'Kurdish' && kName.isNotEmpty) ? kName : baseName;
        final rawSpecialty = doctorData['specialty'] ?? 'Specialty Unknown';
        final doctorSpecialty = LocalizationService.translate(rawSpecialty, lang);
        final doctorLocation = doctorData['clinicLocation'] ?? 'Location Unknown';
        final doctorCity = LocalizationService.translate(doctorData['city'] ?? 'Erbil', lang);
        final doctorPhone = doctorData['phoneNumber'] ?? '+964 000 000 0000';
        final lat = doctorData['latitude']?.toDouble() ?? 36.190;
        final lng = doctorData['longitude']?.toDouble() ?? 43.993;

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
                              children: [
                                Icon(Icons.arrow_back_ios, color: AppColors.white, size: 14),
                                const SizedBox(width: 4),
                                Text(LocalizationService.translate('back', lang), style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => AppState.instance.toggleFavoriteDoctor(doctorId),
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
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(Icons.person, color: AppColors.white, size: 40),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doctorName, style: TextStyle(color: AppColors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(doctorSpecialty, style: TextStyle(color: AppColors.white.withValues(alpha: 0.8), fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(LocalizationService.translate('clinic_info', lang).toUpperCase(), style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.borderTertiary),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.redSoft,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.location_on, color: AppColors.red, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(LocalizationService.translate('address', lang), style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                      Text('$doctorLocation, $doctorCity', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.purpleSoft,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.phone, color: AppColors.purple, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(LocalizationService.translate('phone', lang), style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                      Text(
                                        '\u200E$doctorPhone',
                                        textDirection: TextDirection.ltr,
                                        style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: ElevatedButton.icon(
                              onPressed: () => MapService.launchMaps(lat, lng, doctorName),
                              icon: Icon(Icons.directions_outlined, color: AppColors.white),
                              label: Text(LocalizationService.translate('get_directions', lang), style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentGreen,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final Uri launchUri = Uri(scheme: 'tel', path: doctorPhone);
                                try {
                                  await launchUrl(launchUri);
                                } catch (_) {}
                              },
                              icon: Icon(Icons.phone, color: AppColors.accentGreen),
                              label: Text(LocalizationService.translate('call_btn', lang), style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold)),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: AppColors.accentGreenSoft),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: 'support@tandrusti.app',
                                queryParameters: {'subject': 'Incorrect info for $doctorName'},
                              );
                              try {
                                await launchUrl(emailLaunchUri);
                              } catch (_) {}
                          },
                          icon: Icon(Icons.warning_amber_rounded, color: AppColors.red),
                          label: Text(LocalizationService.translate('report_incorrect', lang), style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.redSoft),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
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
