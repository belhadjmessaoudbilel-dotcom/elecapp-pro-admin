import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Priorité 1 : --dart-define=SUPABASE_URL=... (CI/CD)
  // Priorité 2 : fichier .env (développement local)
  static String get url {
    const v = String.fromEnvironment('SUPABASE_URL');
    if (v.isNotEmpty) return v;
    final env = dotenv.env['SUPABASE_URL'] ?? '';
    assert(env.isNotEmpty, 'SUPABASE_URL manquant — créez .env ou passez --dart-define');
    return env;
  }

  static String get anonKey {
    const v = String.fromEnvironment('SUPABASE_ANON_KEY');
    if (v.isNotEmpty) return v;
    final env = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    assert(env.isNotEmpty, 'SUPABASE_ANON_KEY manquant — créez .env ou passez --dart-define');
    return env;
  }

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(url: url, publishableKey: anonKey);
  }
}
