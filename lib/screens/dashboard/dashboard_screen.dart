import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:elecapp_core/elecapp_core.dart';
import '../../services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Map<String, dynamic>>> _pending;

  @override
  void initState() {
    super.initState();
    _pending = AuthService.fetchPendingEntreprises();
  }

  void _reload() => setState(() => _pending = AuthService.fetchPendingEntreprises());

  Future<void> _validate(String id) async {
    await AuthService.validateEntreprise(id);
    _reload();
  }

  Future<void> _reject(String id) async {
    await AuthService.rejectEntreprise(id);
    _reload();
  }

  Future<void> _signOut() async {
    await AuthService.signOut();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.text,
      elevation: 0,
      title: const Text('Entreprises à valider'),
      actions: [
        IconButton(icon: const Icon(Icons.logout), onPressed: _signOut),
      ],
    ),
    body: FutureBuilder<List<Map<String, dynamic>>>(
      future: _pending,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final entreprises = snapshot.data ?? [];
        if (entreprises.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.check_circle_outline, size: 48, color: AppColors.successLight),
                const SizedBox(height: 12),
                const Text('Aucune entreprise en attente de validation',
                    style: TextStyle(color: AppColors.textMuted)),
              ]),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => _reload(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: entreprises.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final e = entreprises[i];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(e['name']?.toString().isNotEmpty == true ? e['name'] : 'Sans nom',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.text)),
                  const SizedBox(height: 4),
                  Text(e['email'] ?? '', style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _reject(e['id'] as String),
                        icon: const Icon(Icons.close, size: 18, color: AppColors.dangerLight),
                        label: const Text('Refuser', style: TextStyle(color: AppColors.dangerLight)),
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.dangerLight)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _validate(e['id'] as String),
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Valider'),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.successLight),
                      ),
                    ),
                  ]),
                ]),
              );
            },
          ),
        );
      },
    ),
  );
}
