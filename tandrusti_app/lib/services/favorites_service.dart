import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _docKey = 'favorite_doctors';
  static const String _medKey = 'favorite_medicines';

  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  // ─────────────────────────────────────────────
  // Load favorites: Firestore if logged in, local otherwise
  // ─────────────────────────────────────────────
  static Future<List<String>> getFavoriteDoctors() async {
    if (_uid != null) {
      return await _loadFromFirestore('favDoctors');
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_docKey) ?? [];
  }

  static Future<List<String>> getFavoriteMedicines() async {
    if (_uid != null) {
      return await _loadFromFirestore('favMedicines');
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_medKey) ?? [];
  }

  // ─────────────────────────────────────────────
  // Save favorites: Firestore + local cache
  // ─────────────────────────────────────────────
  static Future<void> saveFavoriteDoctors(List<String> doctors) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_docKey, doctors);
    if (_uid != null) {
      await _saveToFirestore('favDoctors', doctors);
    }
  }

  static Future<void> saveFavoriteMedicines(List<String> medicines) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_medKey, medicines);
    if (_uid != null) {
      await _saveToFirestore('favMedicines', medicines);
    }
  }

  // ─────────────────────────────────────────────
  // Internal Firestore helpers
  // ─────────────────────────────────────────────
  static Future<List<String>> _loadFromFirestore(String field) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final list = data[field];
        if (list is List) {
          return list.map((e) => e.toString()).toList();
        }
      }
    } catch (e) {
      // fallback to local
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(field == 'favDoctors' ? _docKey : _medKey) ?? [];
  }

  static Future<void> _saveToFirestore(String field, List<String> ids) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .set({field: ids}, SetOptions(merge: true));
    } catch (e) {
      // silently fail — local cache already updated
    }
  }
}
