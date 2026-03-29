import 'package:flutter/material.dart';
import 'dart:async';
import '../main.dart';
import '../services/app_state.dart';
import '../services/localization_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'directory_screen.dart';
import 'medicine_screen.dart';
import 'reminder_screen.dart';
import 'settings_screen.dart';
import 'my_doctors_screen.dart';
import 'my_medicines_screen.dart';
import 'test_guide_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentSponsorPage = 0;
  Timer? _bannerTimer;

  final List<Map<String, dynamic>> sponsors = [
    {
      'title_en': 'UK Pizza',
      'title_ku': 'یوکا پیتزا',
      'subtitle_en': 'Freshly baked for you',
      'subtitle_ku': 'بە تازەیی بۆ تۆ برژێندراوە',
      'color1': AppColors.red,
      'color2': AppColors.redSoft,
      'icon': Icons.local_pizza,
    },
    {
      'title_en': 'Asiacell',
      'title_ku': 'ئاسیاسێڵ',
      'subtitle_en': 'Connecting you everywhere',
      'subtitle_ku': 'لە هەموو شوێنێک دەتگەیەنێت',
      'color1': AppColors.purple,
      'color2': AppColors.purpleSoft,
      'icon': Icons.cell_tower,
    },
    {
      'title_en': 'Korek Telecom',
      'title_ku': 'کۆڕەک تێلیکۆم',
      'subtitle_en': 'Always with you',
      'subtitle_ku': 'هەمیشە لەگەڵتە',
      'color1': AppColors.amber,
      'color2': AppColors.amberSoft,
      'icon': Icons.phone_android,
    },
    {
      'title_en': 'FastPay',
      'title_ku': 'فاست پەی',
      'subtitle_en': 'Fast & secure payments',
      'subtitle_ku': 'پارەدان بە خێرا و پارێزراوی',
      'color1': AppColors.blue,
      'color2': AppColors.blueSoft,
      'icon': Icons.account_balance_wallet,
    },
    {
      'title_en': 'Cihan Group',
      'title_ku': 'گروپی جیهان',
      'subtitle_en': 'Quality in everything we do',
      'subtitle_ku': 'کوالیتی لە هەموو کارێکماندا',
      'color1': AppColors.accentGreen,
      'color2': AppColors.accentGreenSoft,
      'icon': Icons.business,
    }
  ];

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentSponsorPage < sponsors.length - 1) {
        _currentSponsorPage++;
      } else {
        _currentSponsorPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentSponsorPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final lang = AppState.instance.language;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // LEFT SIDE: Profile Icon + Tandrusti Text
                      ListenableBuilder(
                        listenable: AuthService.instance,
                        builder: (context, _) {
                          final user = AuthService.instance.currentUser;
                          
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (user == null) {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                                  } else {
                                    // Logout confirm dialog
                                    showDialog(
                                      context: context,
                                      builder: (c) => AlertDialog(
                                        backgroundColor: AppColors.surface,
                                        title: Text('Logout', style: TextStyle(color: AppColors.textPrimary)),
                                        content: Text('Are you sure you want to log out?', style: TextStyle(color: AppColors.textSecondary)),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(c), child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
                                          TextButton(
                                            onPressed: () {
                                              AuthService.instance.logout();
                                              Navigator.pop(c);
                                            },
                                            child: Text('Logout', style: TextStyle(color: AppColors.red)),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.accentGreenSoft),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(user == null ? Icons.person_outline : Icons.person, color: AppColors.accentGreen, size: 20),
                                      if (user != null) ...[
                                        SizedBox(width: 6),
                                        Text(user.displayName.split(' ')[0], style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                LocalizationService.translate('app_title', lang),
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                            ],
                          );
                        }
                      ),

                      // RIGHT SIDE: Language Toggle & Settings
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              AppState.instance.toggleLanguage(
                                lang == 'English' ? 'Kurdish' : 'English'
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.accentGreenSoft),
                              ),
                              child: Text(
                                lang == 'English' ? 'Kurdish (Sorani)' : 'En',
                                style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          // Settings gear
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.accentGreenSoft),
                              ),
                              child: Icon(Icons.settings, color: AppColors.accentGreen, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 32),

                  // Sponsor SLIDING BANNER Section
                  SizedBox(
                    height: 140,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: sponsors.length,
                      onPageChanged: (idx) {
                         _currentSponsorPage = idx;
                      },
                      itemBuilder: (context, index) {
                         final sponsor = sponsors[index];
                         return Container(
                           margin: EdgeInsets.symmetric(horizontal: 4),
                           padding: EdgeInsets.all(20),
                           decoration: BoxDecoration(
                             gradient: LinearGradient(
                               colors: [sponsor['color1'], sponsor['color1'].withOpacity(0.7)],
                               begin: Alignment.topLeft,
                               end: Alignment.bottomRight,
                             ),
                             borderRadius: BorderRadius.circular(24),
                             boxShadow: [
                               BoxShadow(
                                 color: sponsor['color1'].withOpacity(0.3),
                                 blurRadius: 10,
                                 offset: Offset(0, 4),
                               )
                             ]
                           ),
                           child: Directionality(
                             textDirection: lang == 'English' ? TextDirection.ltr : TextDirection.rtl,
                             child: Row(
                               children: [
                                 Expanded(
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Text(
                                         LocalizationService.translate('sponsored', lang),
                                         style: TextStyle(color: AppColors.white.withOpacity(0.8), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                                       ),
                                       SizedBox(height: 4),
                                       Text(
                                         lang == 'English' ? sponsor['title_en'] : sponsor['title_ku'],
                                         style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                       ),
                                       SizedBox(height: 6),
                                       Text(
                                         lang == 'English' ? sponsor['subtitle_en'] : sponsor['subtitle_ku'],
                                         style: TextStyle(color: AppColors.white.withOpacity(0.9), fontSize: 13),
                                       ),
                                     ],
                                   )
                                 ),
                                 Container(
                                   padding: EdgeInsets.all(12),
                                   decoration: BoxDecoration(
                                     color: AppColors.white.withOpacity(0.2),
                                     shape: BoxShape.circle
                                   ),
                                   child: Icon(sponsor['icon'], color: AppColors.white, size: 36),
                                 )
                               ],
                             ),
                           )
                         );
                      },
                    ),
                  ),
                  
                  // Dot Indicators for the slider
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(sponsors.length, (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentSponsorPage == index ? AppColors.accentGreen : AppColors.borderTertiary,
                      ),
                    )),
                  ),

                  SizedBox(height: 24),

                  // 2x2 Feature Grid
                  Row(
                    children: [
                      Expanded(child: _buildFeatureCard(
                        context,
                        icon: Icons.local_hospital,
                        iconColor: AppColors.blue,
                        bgColor: AppColors.blueSoft,
                        label: LocalizationService.translate('directory', lang),
                        screen: const DirectoryScreen(),
                      )),
                      SizedBox(width: 14),
                      Expanded(child: _buildFeatureCard(
                        context,
                        icon: Icons.biotech,
                        iconColor: AppColors.amber,
                        bgColor: AppColors.amberSoft,
                        label: LocalizationService.translate('lab_guide', lang),
                        screen: const TestGuideScreen(),
                      )),
                    ],
                  ),
                  SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _buildFeatureCard(
                        context,
                        icon: Icons.medication,
                        iconColor: AppColors.red,
                        bgColor: AppColors.redSoft,
                        label: LocalizationService.translate('medicines', lang),
                        screen: const MedicineScreen(),
                      )),
                      SizedBox(width: 14),
                      Expanded(child: _buildFeatureCard(
                        context,
                        icon: Icons.alarm,
                        iconColor: AppColors.purple,
                        bgColor: AppColors.purpleSoft,
                        label: LocalizationService.translate('reminders', lang),
                        screen: const ReminderScreen(),
                      )),
                    ],
                  ),

                  SizedBox(height: 16),
                  Divider(color: AppColors.borderTertiary, thickness: 1),
                  SizedBox(height: 16),

                  // Saved Bookmarks Grid
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MyDoctorsScreen())),
                          child: Container(
                            height: 140,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.borderTertiary),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.redSoft,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.badge, color: AppColors.red, size: 24),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LocalizationService.translate('my_doctors', lang),
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      '${AppState.instance.favDoctors.length} ${LocalizationService.translate('saved', lang)}',
                                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MyMedicinesScreen())),
                          child: Container(
                            height: 140,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.borderTertiary),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.purpleSoft,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.medication, color: AppColors.purple, size: 24),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LocalizationService.translate('my_medicines', lang),
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      '${AppState.instance.favMedicines.length} ${LocalizationService.translate('saved', lang)}',
                                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Adding extra bottom padding to fix the overlapping issue on long screens!
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard(BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String label,
    required Widget screen,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: Container(
        height: 130,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderTertiary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
