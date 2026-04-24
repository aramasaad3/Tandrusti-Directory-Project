import 'package:flutter_test/flutter_test.dart';
import 'package:tandrusti_app/services/localization_service.dart';

/// ============================================================
/// Tandrusti Automated Tests
/// Run with: flutter test
/// ============================================================

void main() {
  // ─────────────────────────────────────────────
  // GROUP 1: LocalizationService Tests
  // ─────────────────────────────────────────────
  group('LocalizationService', () {
    test('Returns English string for English language', () {
      final result = LocalizationService.translate('err_user_not_found', 'English');
      expect(result, 'No account detected on this email.');
    });

    test('Returns Kurdish string for Kurdish language', () {
      final result = LocalizationService.translate('err_user_not_found', 'Kurdish');
      expect(result, 'هیچ هەژمارێک بەم ئیمەیڵە نەدۆزرایەوە.');
    });

    test('Returns key itself if translation not found', () {
      final result = LocalizationService.translate('nonexistent_key', 'English');
      expect(result, 'nonexistent_key');
    });

    test('err_wrong_password is translated in English', () {
      final result = LocalizationService.translate('err_wrong_password', 'English');
      expect(result, 'Incorrect email or password.');
    });

    test('err_wrong_password is translated in Kurdish', () {
      final result = LocalizationService.translate('err_wrong_password', 'Kurdish');
      expect(result, 'ئیمەیڵ یان وشەی نهێنی هەڵەیە.');
    });

    test('err_email_in_use is translated in English', () {
      final result = LocalizationService.translate('err_email_in_use', 'English');
      expect(result, 'An account already exists for this email.');
    });

    test('err_weak_password is translated in English', () {
      final result = LocalizationService.translate('err_weak_password', 'English');
      expect(result, 'Password is too weak (minimum 6 characters).');
    });

    test('err_network is translated in Kurdish', () {
      final result = LocalizationService.translate('err_network', 'Kurdish');
      expect(result, 'کێشەی هێڵ هەیە. تکایە هێڵی ئینتەرنێتەکەت بپشکنە.');
    });

    test('reset_email_sent exists in English', () {
      final result = LocalizationService.translate('reset_email_sent', 'English');
      expect(result, 'Reset Link Sent!');
    });

    test('reset_email_sent exists in Kurdish', () {
      final result = LocalizationService.translate('reset_email_sent', 'Kurdish');
      expect(result, 'لینکەکە نێردرا!');
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 2: Error Code Mapping Logic Tests
  // ─────────────────────────────────────────────
  group('Error Code Mapping', () {
    // Helper: simulate the _getErrorCode logic
    String getErrorCode(String code) {
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

    test('user-not-found maps to err_user_not_found', () {
      expect(getErrorCode('user-not-found'), 'err_user_not_found');
    });

    test('wrong-password maps to err_wrong_password', () {
      expect(getErrorCode('wrong-password'), 'err_wrong_password');
    });

    test('invalid-credential maps to err_wrong_password', () {
      expect(getErrorCode('invalid-credential'), 'err_wrong_password');
    });

    test('email-already-in-use maps to err_email_in_use', () {
      expect(getErrorCode('email-already-in-use'), 'err_email_in_use');
    });

    test('weak-password maps to err_weak_password', () {
      expect(getErrorCode('weak-password'), 'err_weak_password');
    });

    test('too-many-requests maps to err_too_many_requests', () {
      expect(getErrorCode('too-many-requests'), 'err_too_many_requests');
    });

    test('network-request-failed maps to err_network', () {
      expect(getErrorCode('network-request-failed'), 'err_network');
    });

    test('unknown code maps to err_unknown', () {
      expect(getErrorCode('some-random-code'), 'err_unknown');
    });

    test('Full pipeline: code → key → English message', () {
      final code = getErrorCode('user-not-found');
      final message = LocalizationService.translate(code, 'English');
      expect(message, 'No account detected on this email.');
    });

    test('Full pipeline: code → key → Kurdish message', () {
      final code = getErrorCode('email-already-in-use');
      final message = LocalizationService.translate(code, 'Kurdish');
      expect(message, 'هەژمارێک پێشتر بەم ئیمەیڵە دروست کراوە.');
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 3: Email Validation Tests
  // ─────────────────────────────────────────────
  group('Email Validation', () {
    bool isValidEmail(String email) {
      return RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(email);
    }

    test('Valid email passes', () {
      expect(isValidEmail('test@gmail.com'), true);
    });

    test('Valid email with dots passes', () {
      expect(isValidEmail('user.name@domain.co'), true);
    });

    test('Missing @ fails', () {
      expect(isValidEmail('testgmail.com'), false);
    });

    test('Missing domain fails', () {
      expect(isValidEmail('test@'), false);
    });

    test('Empty string fails', () {
      expect(isValidEmail(''), false);
    });

    test('Random string fails', () {
      expect(isValidEmail('notanemail'), false);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 4: Password Strength Tests
  // ─────────────────────────────────────────────
  group('Password Strength', () {
    bool isStrongEnough(String password) => password.length >= 6;

    test('6 character password is accepted', () {
      expect(isStrongEnough('abc123'), true);
    });

    test('Long password is accepted', () {
      expect(isStrongEnough('SuperSecurePassword123!'), true);
    });

    test('5 character password is rejected', () {
      expect(isStrongEnough('short'), false);
    });

    test('Empty password is rejected', () {
      expect(isStrongEnough(''), false);
    });
  });
}
