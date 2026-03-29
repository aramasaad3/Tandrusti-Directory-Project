import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/app_state.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';
import 'screens/alarm_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// --- Tandrusti Color Palette ---
class AppColors {
  static bool get _isDark => AppState.instance.isDarkMode;

  static Color get background => _isDark ? Color(0xFF0A0F0D) : Color(0xFFF0FDF4);
  static Color get surface => _isDark ? Color(0xFF121A16) : Color(0xFFFFFFFF);
  static Color get appBarTint => _isDark ? Color(0xFF121A16) : Color(0xFFFFFFFF);
  static Color get borderTertiary => _isDark ? Color(0xFF1E2D24) : Color(0xFFE2E8F0);
  
  static Color get textPrimary => _isDark ? Color(0xFFE8F5EE) : Color(0xFF0F172A);
  static Color get textSecondary => _isDark ? Color(0xFF7A9E8A) : Color(0xFF64748B);
  
  static Color accentGreen = Color(0xFF22C55E);
  static Color get accentGreenSoft => Color(0xFF22C55E).withOpacity(0.15);
  
  static Color amber = Color(0xFFF59E0B);
  static Color get amberSoft => Color(0xFFF59E0B).withOpacity(0.15);
  
  static Color blue = Color(0xFF3B82F6);
  static Color get blueSoft => Color(0xFF3B82F6).withOpacity(0.15);
  
  static Color red = Color(0xFFEF4444);
  static Color get redSoft => Color(0xFFEF4444).withOpacity(0.15);
  
  static Color purple = Color(0xFFA855F7);
  static Color get purpleSoft => Color(0xFFA855F7).withOpacity(0.15);
  
  static Color get white => _isDark ? Color(0xFFFFFFFF) : Color(0xFFFFFFFF);
  
  static Color get filterInactive => _isDark ? Color(0xFF182018) : Color(0xFFF1F5F9);
  static Color get inputHint => _isDark ? Color(0xFF3A5048) : Color(0xFF94A3B8);
  
  static LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.init();
  await AppState.instance.loadFavorites();
  await AuthService.instance.init();

  final initialPayload = await NotificationService.getInitialAlarmPayload();

  runApp(TandrustiApp(initialAlarmPayload: initialPayload));
}

class TandrustiApp extends StatelessWidget {
  final String? initialAlarmPayload;
  const TandrustiApp({super.key, this.initialAlarmPayload});

  Widget _getHomeWidget() {
    if (initialAlarmPayload != null && initialAlarmPayload!.startsWith('ALARM|')) {
      final parts = initialAlarmPayload!.split('|');
      if (parts.length >= 3) {
        return AlarmScreen(title: parts[1], body: parts[2]);
      }
    }
    return const HomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final isKurdish = AppState.instance.language == 'Kurdish';

        Widget app = MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Tandrusti',
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            final textScale = isKurdish ? 1.25 : 1.0;
            return Directionality(
              textDirection: isKurdish ? TextDirection.rtl : TextDirection.ltr,
              child: MediaQuery(
                 data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(textScale),
                 ),
                 child: child!,
              ),
            );
          },
          themeMode: AppState.instance.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Color(0xFFF0FDF4),
            colorScheme: ColorScheme.light(
              primary: AppColors.accentGreen,
              secondary: AppColors.accentGreen,
              surface: Color(0xFFFFFFFF),
              onPrimary: Color(0xFFFFFFFF),
              onSecondary: Color(0xFF0F172A),
              onSurface: Color(0xFF0F172A),
            ),
            cardColor: Color(0xFFFFFFFF),
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFFFFFFFF),
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: IconThemeData(color: AppColors.accentGreen),
            ),
            textTheme: GoogleFonts.interTextTheme(
               ThemeData.light().textTheme.copyWith(
                  bodyLarge: TextStyle(color: Color(0xFF0F172A)),
                  bodyMedium: TextStyle(color: Color(0xFF0F172A)),
                  titleMedium: TextStyle(color: Color(0xFF0F172A)),
                  labelLarge: TextStyle(color: Color(0xFF64748B)),
               )
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.dark(
              primary: AppColors.accentGreen,
              secondary: AppColors.accentGreen,
              surface: AppColors.surface,
              onPrimary: AppColors.white,
              onSecondary: AppColors.background,
              onSurface: AppColors.textPrimary,
            ),
            cardColor: AppColors.surface,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.appBarTint,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: IconThemeData(color: AppColors.accentGreen),
            ),
            textTheme: GoogleFonts.interTextTheme(
              ThemeData.dark().textTheme.copyWith(
                bodyLarge: TextStyle(color: AppColors.textPrimary),
                bodyMedium: TextStyle(color: AppColors.textPrimary),
                titleMedium: TextStyle(color: AppColors.textPrimary),
                labelLarge: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            useMaterial3: true,
          ),
          home: _getHomeWidget(),
        );

        if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) {
          return Container(
            color: Color(0xFF030504),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 450,
                  height: 900,
                  child: app,
                ),
              ),
            ),
          );
        }

        return app;
      },
    );
  }
}
