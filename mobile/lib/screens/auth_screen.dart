import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/theme_toggle_button.dart';
import 'main_shell.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _enterApp() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainShell()));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final app = context.read<AppState>();
    final canContinue = _emailController.text.trim().contains('@');

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
          child: Column(
            children: [
              Align(alignment: Alignment.topRight, child: const ThemeToggleButton()),
              const Spacer(),
              Text('أَيَاقْلِي', style: arabicFont(size: 30, weight: FontWeight.w700, color: c.primary)),
              const SizedBox(height: 6),
              Text('Ayaqli', style: latinFont(size: 26, weight: FontWeight.w600, color: c.text)),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 260),
                child: Text(
                  'Recherchez, écoutez et mémorisez le Coran, verset par verset, par concept.',
                  textAlign: TextAlign.center,
                  style: latinFont(size: 14, color: c.textMuted, height: 1.6),
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                onChanged: (_) => setState(() {}),
                keyboardType: TextInputType.emailAddress,
                style: latinFont(size: 15, color: c.text),
                decoration: InputDecoration(
                  hintText: 'email@exemple.com',
                  hintStyle: latinFont(size: 15, color: c.textFaint),
                  filled: true,
                  fillColor: c.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c.primary)),
                ),
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                label: 'Continuer',
                onPressed: canContinue
                    ? () {
                        app.signInWithEmail(_emailController.text.trim());
                        _enterApp();
                      }
                    : null,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(child: Divider(color: c.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('ou', style: latinFont(size: 13, color: c.textFaint)),
                  ),
                  Expanded(child: Divider(color: c.border)),
                ],
              ),
              const SizedBox(height: 18),
              OutlineAppButton(
                label: "Continuer en tant qu'invité",
                onPressed: () {
                  app.continueAsGuest();
                  _enterApp();
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
