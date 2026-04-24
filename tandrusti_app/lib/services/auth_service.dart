import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'app_state.dart';

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
        // Reload favorites from Firestore for this account
        await AppState.instance.loadFavorites();
      } else {
        currentUser = null;
        // Clear favorites from memory on logout
        AppState.instance.clearFavorites();
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

  // Returns a translatable error key (not the translated string)
  String _getErrorCode(String code) {
    switch (code) {
      case 'user-not-found':
        return 'err_user_not_found';
      case 'wrong-password':
      case 'invalid-credential':
        return 'err_wrong_password';
      case 'invalid-email':
        return 'err_invalid_email';
      case 'email-already-in-use':
        return 'err_email_in_use';
      case 'weak-password':
        return 'err_weak_password';
      case 'too-many-requests':
        return 'err_too_many_requests';
      case 'network-request-failed':
        return 'err_network';
      default:
        return 'err_unknown';
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
      return 'err_unknown';
    } on auth.FirebaseAuthException catch (e) {
      return _getErrorCode(e.code);
    } catch (e) {
      return 'err_unknown';
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
      return 'err_unknown';
    } on auth.FirebaseAuthException catch (e) {
      return _getErrorCode(e.code);
    } catch (e) {
      return 'err_unknown';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on auth.FirebaseAuthException catch (e) {
      return _getErrorCode(e.code);
    } catch (e) {
      return 'err_unknown';
    }
  }


  Future<String?> sendEmailVerification() async {
    try {
      if (_auth.currentUser != null && !_auth.currentUser!.emailVerified) {
        await _auth.currentUser!.sendEmailVerification();
        return null;
      }
      return "User not found or already verified.";
    } on auth.FirebaseAuthException catch (e) {
      return e.message ?? 'Failed to send verification email.';
    } catch (e) {
      return e.toString();
    }
  }


  Future<String?> updateDisplayName({required String newName, required String password}) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) return "No user logged in.";

      // Re-authenticate
      final cred = auth.EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(cred);

      // Update in Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'displayName': newName.trim(),
      });
      
      // Update locally
      await _fetchUser(user.uid);
      return null; // Success
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return 'Incorrect password.';
      }
      return e.message ?? 'Failed to update profile.';
    } catch (e) {
      return e.toString();
    }
  }
}
