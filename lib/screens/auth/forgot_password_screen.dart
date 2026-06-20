import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:elecapp_core/elecapp_core.dart';
import '../../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _loading = false;
  String? _error, _success;

  Future<void> _submit() async {
    final err = SecurityService.validateEmail(_email.text);
    if (err != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err), backgroundColor: AppColors.dangerLight));
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _success = null;
    });
    try {
      await AuthService.resetPassword(_email.text);
      if (!mounted) return;
      setState(() {
        _loading = false;
        _success = 'Email envoyé. Vérifiez votre boîte de réception pour réinitialiser votre mot de passe.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Erreur : ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.text),
              onPressed: () => context.canPop() ? context.pop() : context.go('/register'),
            ),
          ]),
          const SizedBox(height: 12),
          const Text('Mot de passe oublié',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.text)),
          const SizedBox(height: 8),
          const Text(
            'Indiquez votre adresse email, nous vous envoyons un lien pour réinitialiser votre mot de passe.',
            style: TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 24),

          if (_error != null) ...[
            _banner(_error!, AppColors.dangerLight, Icons.error_outline),
            const SizedBox(height: 16),
          ],
          if (_success != null) ...[
            _banner(_success!, AppColors.successLight, Icons.check_circle_outline),
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
          const SizedBox(height: 24),

          PrimaryButton(label: 'Envoyer le lien', loading: _loading, onTap: _submit, icon: Icons.send),
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
    _email.dispose();
    super.dispose();
  }
}
