import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../services/app_state.dart';
import '../services/localization_service.dart';
import '../services/auth_service.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final lang = AppState.instance.language;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.appBarTint,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 18, color: AppColors.accentGreen),
              onPressed: () => Navigator.pop(context),
            ),
             title: Text(
               LocalizationService.translate('settings', lang),
               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)
             ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalizationService.translate('app_preferences', lang).toUpperCase(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderTertiary),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.blueSoft,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.language, color: AppColors.blue, size: 20),
                        ),
                        title: Text(LocalizationService.translate('language', lang), style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                        subtitle: Text(lang == 'English' ? 'English (US)' : 'کوردی (سۆرانی)', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        trailing: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: lang,
                            dropdownColor: AppColors.surface,
                            icon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                            items: [
                              DropdownMenuItem(value: 'English', child: Text('English', style: TextStyle(color: AppColors.textPrimary))),
                              DropdownMenuItem(value: 'Kurdish', child: Text('کوردی', style: TextStyle(color: AppColors.textPrimary))),
                            ],
                            onChanged: (val) {
                              if (val != null) AppState.instance.toggleLanguage(val);
                            },
                          ),
                        ),
                      ),
                      Divider(height: 1, color: AppColors.filterInactive),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.purpleSoft,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.dark_mode, color: AppColors.purple, size: 20),
                        ),
                        title: Text(LocalizationService.translate('theme', lang), style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                        subtitle: Text(LocalizationService.translate('dark_mode_sub', lang), style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        trailing: Theme(
                          data: ThemeData(
                            useMaterial3: true,
                            colorScheme: ColorScheme.dark(primary: AppColors.accentGreen),
                          ),
                          child: Switch(
                             value: AppState.instance.isDarkMode,
                             onChanged: (val) {
                                AppState.instance.toggleTheme(val);
                             },
                             activeThumbColor: AppColors.accentGreen,
                          ),
                        )
                      ),
                      if (AuthService.instance.currentUser != null) ...[
                        Divider(height: 1, color: AppColors.filterInactive),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.accentGreenSoft,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.person, color: AppColors.accentGreen, size: 20),
                          ),
                          title: Text(LocalizationService.translate('edit_profile', lang), style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                          subtitle: Text(LocalizationService.translate('edit_profile_subtitle', lang), style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                          },
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                Text(
                  LocalizationService.translate('info_support', lang).toUpperCase(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                     color: AppColors.surface,
                     borderRadius: BorderRadius.circular(16),
                     border: Border.all(color: AppColors.borderTertiary),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () async {
                         final Uri emailLaunchUri = Uri(
                           scheme: 'mailto',
                           path: 'support@tandrusti.app',
                           queryParameters: {'subject': LocalizationService.translate('email_subject', lang)},
                         );
                         try {
                           await launchUrl(emailLaunchUri);
                         } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                   content: Text(LocalizationService.translate('email_error', lang)),
                                   backgroundColor: AppColors.red,
                                )
                              );
                            }
                         }
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.redSoft,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.bug_report, color: AppColors.red, size: 20),
                        ),
                        title: Text(LocalizationService.translate('report_error_title', lang), style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                        subtitle: Text(LocalizationService.translate('report_error_subtitle', lang), style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
                      ),
                    ),
                  ),
                ),
                
                 const SizedBox(height: 48),
                 Center(
                   child: Text(
                     'Tandrusti App Version 1.0.0',
                     style: TextStyle(color: AppColors.textSecondary, fontSize: 12)
                   )
                 )
              ],
            ),
          ),
        );
      },
    );
  }
}
