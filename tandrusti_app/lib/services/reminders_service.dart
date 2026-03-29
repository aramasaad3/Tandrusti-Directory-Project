import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder_model.dart';

class RemindersService {
  static const String _key = 'user_reminders';

  static Future<List<Reminder>> getReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? data = prefs.getStringList(_key);
    if (data == null) return [];
    
    return data.map((item) => Reminder.fromJson(jsonDecode(item))).toList();
  }

  static Future<void> saveReminders(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data = reminders.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_key, data);
  }
}
