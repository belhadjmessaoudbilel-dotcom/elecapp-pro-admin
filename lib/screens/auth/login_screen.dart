import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:elecapp_core/elecapp_core.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _showPass = false, _loading = false;
  String? _error;

  Future<void> _submit() async {
    final emailErr = SecurityService.validateEmail(_email.text);
    if (emailErr != null) return _snack(emailErr);
    if (_pass.text.isEmpty) return _snack('Mot de passe requis');

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.signIn(email: _email.text, password: _pass.text);
      if (!mounted) return;
      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Connexion impossible : ${e.toString()}';
      });
    }
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: AppColors.dangerLight),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Connexion',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.text)),
          const SizedBox(height: 6),
          const Text('Espace administrateur Elecapp Pro', style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 24),

          if (_error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.dangerLight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.dangerLight.withValues(alpha: 0.4)),
              ),
              child: Row(children: [
                const Icon(Icons.error_outline, color: AppColors.dangerLight, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(_error!, style: const TextStyle(color: AppColors.dangerLight, fontSize: 13))),
              ]),
            ),
            const SizedBox(height: 16),
          ],

          LabeledField(
            label: 'Adresse email',
            child: TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'vous@exemple.fr'),
            ),
          ),
          const SizedBox(height: 14),
          LabeledField(
            label: 'Mot de passe',
            child: TextFormField(
              controller: _pass,
              obscureText: !_showPass,
              decoration: InputDecoration(
                hintText: 'Votre mot de passe',
                suffixIcon: IconButton(
                  icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility, color: AppColors.textMuted),
                  onPressed: () => setState(() => _showPass = !_showPass),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => context.go('/forgot-password'),
              child: const Text('Mot de passe oublié ?',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
            ),
          ),
          const SizedBox(height: 24),

          PrimaryButton(label: 'Se connecter', loading: _loading, onTap: _submit, icon: Icons.login),
          const SizedBox(height: 20),

          Center(
            child: GestureDetector(
              onTap: () => context.go('/register'),
              child: const Text("Pas encore de compte ? S'inscrire",
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ),
    ),
  );

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }
}
