import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:elecapp_core/elecapp_core.dart';

class AuthService {
  static SupabaseClient get _db => SupabaseConfig.client;

  // Le profil (table public.profiles) est créé automatiquement par le trigger
  // SQL on_auth_user_created à partir des métadonnées passées ici.
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  }) =>
      _db.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'role': 'admin'},
      );

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) =>
      _db.auth.signInWithPassword(email: email.trim(), password: password);

  static Future<void> signInWithGoogle() => _db.auth.signInWithOAuth(
    OAuthProvider.google,
    redirectTo: kIsWeb ? null : 'io.elecappadmin://login-callback/',
  );

  static Future<void> resetPassword(String email) => _db.auth.resetPasswordForEmail(
    email.trim(),
    redirectTo: kIsWeb ? null : 'io.elecappadmin://reset-callback/',
  );

  static Future<void> signOut() => _db.auth.signOut();

  static bool get isLoggedIn => _db.auth.currentSession != null;

  // ── Validation des entreprises ──────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> fetchPendingEntreprises() => _db
      .from('profiles')
      .select()
      .eq('role', 'manager')
      .eq('status', 'pending')
      .order('created_at');

  static Future<void> validateEntreprise(String profileId) => _db
      .from('profiles')
      .update({'status': 'active'})
      .eq('id', profileId);

  static Future<void> rejectEntreprise(String profileId) => _db
      .from('profiles')
      .update({'status': 'rejected'})
      .eq('id', profileId);
}
