import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String role; // 'user' or 'admin'

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      role: map['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'role': role,
    };
  }
}

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  auth.User? get firebaseUser => _auth.currentUser;
  UserModel? currentUser;

  Future<void> init() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        await _fetchUser(user.uid);
      } else {
        currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> _fetchUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        currentUser = UserModel.fromMap(doc.data()!, doc.id);
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (cred.user != null) {
        // Create user in Firestore
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'email': email,
          'displayName': name,
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        await _fetchUser(cred.user!.uid);
        return null; // Success
      }
      return "Signup failed.";
    } on auth.FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred during signup.";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (cred.user != null) {
        await _fetchUser(cred.user!.uid);
        return null; // Success
      }
      return "Login failed.";
    } on auth.FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred during login.";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
