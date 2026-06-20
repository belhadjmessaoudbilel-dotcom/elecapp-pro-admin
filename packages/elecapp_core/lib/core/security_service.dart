import 'package:email_validator/email_validator.dart';

// ── Validation partagée — formulaires d'authentification ──────────────────

class SecurityService {
  static bool isValidEmail(String email) => EmailValidator.validate(email.trim());

  static String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email requis';
    if (!isValidEmail(v)) return 'Adresse email invalide';
    return null;
  }

  static String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Mot de passe requis';
    if (v.length < 8) return 'Minimum 8 caractères';
    if (!v.contains(RegExp(r'[A-Z]'))) return 'Au moins 1 majuscule requise';
    if (!v.contains(RegExp(r'[0-9]'))) return 'Au moins 1 chiffre requis';
    return null;
  }

  static String? validateRequired(String? v, String label) {
    if (v == null || v.trim().isEmpty) return '$label requis';
    return null;
  }

  // ── Force du mot de passe ─────────────────────────────────────────────

  static PasswordStrength checkStrength(String password) {
    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]'))) score++;
    if (score <= 1) return PasswordStrength.faible;
    if (score <= 2) return PasswordStrength.moyen;
    if (score <= 3) return PasswordStrength.bon;
    return PasswordStrength.fort;
  }
}

enum PasswordStrength { faible, moyen, bon, fort }

extension PasswordStrengthExt on PasswordStrength {
  String get label {
    switch (this) {
      case PasswordStrength.faible: return 'Faible';
      case PasswordStrength.moyen:  return 'Moyen';
      case PasswordStrength.bon:    return 'Bon';
      case PasswordStrength.fort:   return 'Fort';
    }
  }
  double get progress {
    switch (this) {
      case PasswordStrength.faible: return 0.25;
      case PasswordStrength.moyen:  return 0.5;
      case PasswordStrength.bon:    return 0.75;
      case PasswordStrength.fort:   return 1.0;
    }
  }
  int get color {
    switch (this) {
      case PasswordStrength.faible: return 0xFFEF4444;
      case PasswordStrength.moyen:  return 0xFFF59E0B;
      case PasswordStrength.bon:    return 0xFF3B82F6;
      case PasswordStrength.fort:   return 0xFF22C55E;
    }
  }
}
