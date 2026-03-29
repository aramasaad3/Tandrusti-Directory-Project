 import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _docKey = 'favorite_doctors';
  static const String _medKey = 'favorite_medicines';

  static Future<List<String>> getFavoriteDoctors() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_docKey) ?? [];
  }

  static Future<List<String>> getFavoriteMedicines() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_medKey) ?? [];
  }

  static Future<void> toggleFavoriteDoctor(String doctorId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> current = prefs.getStringList(_docKey) ?? [];
    if (current.contains(doctorId)) {
      current.remove(doctorId);
    } else {
      current.add(doctorId);
    }
    await prefs.setStringList(_docKey, current);
  }

  static Future<void> toggleFavoriteMedicine(String medicineId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> current = prefs.getStringList(_medKey) ?? [];
    if (current.contains(medicineId)) {
      current.remove(medicineId);
    } else {
      current.add(medicineId);
    }
    await prefs.setStringList(_medKey, current);
  }

  static Future<void> saveFavoriteDoctors(List<String> doctors) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_docKey, doctors);
  }

  static Future<void> saveFavoriteMedicines(List<String> medicines) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_medKey, medicines);
  }
}
