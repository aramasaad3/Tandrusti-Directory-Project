import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'favorites_service.dart';
import 'reminders_service.dart';
import '../models/reminder_model.dart';
import '../screens/alarm_screen.dart';
import '../main.dart'; // for navigatorKey

class AppState extends ChangeNotifier {
  String _language = 'English';
  bool _isDarkMode = true;
  List<String> _favDoctors = [];
  List<String> _favMedicines = [];
  List<Reminder> _reminders = [];
  
  // ignore: unused_field
  Timer? _alarmTimer;
  String _lastAlarmedTime = "";

  AppState._internal() {
    _startAlarmListener();
  }

  void _startAlarmListener() {
    _alarmTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final now = DateTime.now();
      final currentTimeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

      if (_lastAlarmedTime == currentTimeStr) return;

      for (var reminder in _reminders) {
        if (reminder.isEnabled && reminder.timeText == currentTimeStr) {
          _lastAlarmedTime = currentTimeStr;
          _triggerInstantAlarmPopup(reminder.medicineName, reminder.dosage);
          break;
        }
      }
    });
  }

  void _triggerInstantAlarmPopup(String title, String body) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (_) => AlarmScreen(title: title, body: body),
        ),
      );
    }
  }

  String get language => _language;
  bool get isDarkMode => _isDarkMode;
  List<String> get favDoctors => _favDoctors;
  List<String> get favMedicines => _favMedicines;
  List<Reminder> get reminders => _reminders;

  void toggleLanguage(String newLang) async {
    _language = newLang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', newLang);
  }

  void toggleTheme(bool isDark) async {
    _isDarkMode = isDark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('app_dark_mode', isDark);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('app_language') ?? 'English';
    _isDarkMode = prefs.getBool('app_dark_mode') ?? true;

    _favDoctors = await FavoritesService.getFavoriteDoctors();
    _favMedicines = await FavoritesService.getFavoriteMedicines();
    _reminders = await RemindersService.getReminders();
    notifyListeners();
  }

  Future<void> addReminder(Reminder r) async {
    _reminders.add(r);
    await RemindersService.saveReminders(_reminders);
    notifyListeners();
  }

  Future<void> deleteReminder(String id) async {
    _reminders.removeWhere((r) => r.id == id);
    await RemindersService.saveReminders(_reminders);
    notifyListeners();
  }

  void toggleFavoriteDoctor(String id) {
    if (_favDoctors.contains(id)) {
      _favDoctors.remove(id);
    } else {
      _favDoctors.add(id);
    }
    notifyListeners();
    FavoritesService.saveFavoriteDoctors(_favDoctors);
  }

  void toggleFavoriteMedicine(String id) {
    if (_favMedicines.contains(id)) {
      _favMedicines.remove(id);
    } else {
      _favMedicines.add(id);
    }
    notifyListeners();
    FavoritesService.saveFavoriteMedicines(_favMedicines);
  }

  bool isDocFavorite(String id) => _favDoctors.contains(id);
  bool isMedFavorite(String id) => _favMedicines.contains(id);

  void clearFavorites() {
    _favDoctors = [];
    _favMedicines = [];
    notifyListeners();
  }

  static final AppState instance = AppState._internal();
}
