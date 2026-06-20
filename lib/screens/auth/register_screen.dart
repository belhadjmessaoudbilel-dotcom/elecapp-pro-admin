import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:elecapp_core/elecapp_core.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _showPass = false, _terms = false, _loading = false;
  String? _error, _success;

  PasswordStrength get _strength => SecurityService.checkStrength(_pass.text);
  Color get _strengthColor => Color(_strength.color);

  Future<void> _submitGoogle() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.signInWithGoogle();
      // Web : redirige vers Google — mobile : ouvre le navigateur puis revient via deep link.
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Erreur connexion Google : ${e.toString()}';
      });
    }
  }

  Future<void> _submit() async {
    final nameErr = SecurityService.validateRequired(_name.text, 'Nom');
    final emailErr = SecurityService.validateEmail(_email.text);
    final passErr = SecurityService.validatePassword(_pass.text);
    if (nameErr != null) return _snack(nameErr);
    if (emailErr != null) return _snack(emailErr);
    if (passErr != null) return _snack(passErr);
    if (!_terms) return _snack('Acceptez les conditions générales et la politique de confidentialité');

    setState(() {
      _loading = true;
      _error = null;
      _success = null;
    });
    try {
      await AuthService.signUp(
        email: _email.text.trim(),
        password: _pass.text,
        name: _name.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _loading = false;
        _success = 'Compte créé. Vérifiez votre email pour confirmer votre inscription.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Erreur inscription : ${e.toString()}';
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
          const Text('Créer un compte',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.text)),
          const SizedBox(height: 6),
          const Text('Rejoignez Elecapp Pro', style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 24),

          if (_error != null) ...[
            _banner(_error!, AppColors.dangerLight, Icons.error_outline),
            const SizedBox(height: 16),
          ],
          if (_success != null) ...[
            _banner(_success!, AppColors.successLight, Icons.check_circle_outline),
            const SizedBox(height: 16),
          ],

          // Google
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: _loading ? null : _submitGoogle,
              icon: const Icon(Icons.g_mobiledata, color: Color(0xFFEA4335), size: 26),
              label: const Text('Continuer avec Google',
                  style: TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Row(children: [
            Expanded(child: Container(height: 1, color: AppColors.border)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('OU PAR EMAIL',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.4, color: AppColors.textMuted)),
            ),
            Expanded(child: Container(height: 1, color: AppColors.border)),
          ]),
          const SizedBox(height: 16),

          LabeledField(
            label: 'Nom complet',
            child: TextFormField(controller: _name, decoration: const InputDecoration(hintText: 'Jean Dupont')),
          ),
          const SizedBox(height: 14),
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
            child: Column(children: [
              TextFormField(
                controller: _pass,
                obscureText: !_showPass,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Au moins 8 caractères',
                  suffixIcon: IconButton(
                    icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility, color: AppColors.textMuted),
                    onPressed: () => setState(() => _showPass = !_showPass),
                  ),
                ),
              ),
              if (_pass.text.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _strength.progress,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation(_strengthColor),
                        minHeight: 4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(_strength.label, style: TextStyle(color: _strengthColor, fontSize: 12, fontWeight: FontWeight.w700)),
                ]),
              ],
            ]),
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
          const SizedBox(height: 12),

          GestureDetector(
            onTap: () => setState(() => _terms = !_terms),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: _terms ? AppColors.primary : AppColors.border,
                  border: Border.all(color: _terms ? AppColors.primary : AppColors.border),
                ),
                child: _terms ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text("J'accepte les conditions générales et la politique de confidentialité",
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12, height: 1.5)),
              ),
            ]),
          ),
          const SizedBox(height: 24),

          PrimaryButton(label: 'Créer mon compte', loading: _loading, onTap: _submit, icon: Icons.arrow_forward),
          const SizedBox(height: 20),

          Center(
            child: GestureDetector(
              onTap: () => context.go('/login'),
              child: const Text('Déjà un compte ? Se connecter',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ),
    ),
  );

  Widget _banner(String msg, Color color, IconData icon) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withValues(alpha: 0.4)),
    ),
    child: Row(children: [
      Icon(icon, color: color, size: 16),
      const SizedBox(width: 8),
      Expanded(child: Text(msg, style: TextStyle(color: color, fontSize: 13))),
    ]),
  );

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }
}
