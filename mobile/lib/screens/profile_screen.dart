import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/mock_data.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';
import '../widgets/concept_chip.dart';
import '../widgets/theme_toggle_button.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final app = context.watch<AppState>();
    final isGuest = app.session == SessionState.guest;
    final initial = (app.userEmail?.isNotEmpty == true ? app.userEmail![0] : 'A').toUpperCase();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Profil', style: latinFont(size: 22, weight: FontWeight.w700, color: c.text)),
                const ThemeToggleButton(),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: c.primarySoft, shape: BoxShape.circle),
                  child: Text(initial, style: latinFont(size: 20, weight: FontWeight.w700, color: c.primary)),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isGuest ? 'Invité' : (app.userEmail ?? ''), style: latinFont(size: 16, weight: FontWeight.w600, color: c.text)),
                    const SizedBox(height: 2),
                    Text(
                      '${LearningStats.versesMastered} versets maîtrisés · ${LearningStats.streakDays} jours de série',
                      style: latinFont(size: 12, color: c.textMuted),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),
            _PreferenceGroup(
              label: 'Récitateur favori',
              child: Row(
                children: [
                  for (final r in mockReciters) ...[
                    ConceptChip(label: r.name, active: app.favoriteReciter == r.slug, onTap: () => app.setFavoriteReciter(r.slug)),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            _PreferenceGroup(
              label: 'Langue de traduction',
              child: Row(
                children: [
                  ConceptChip(label: 'Français', active: app.language == 'fr', onTap: () => app.setLanguage('fr')),
                  const SizedBox(width: 8),
                  ConceptChip(label: 'English', active: app.language == 'en', onTap: () => app.setLanguage('en')),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _PreferenceGroup(
              label: 'Apparence',
              child: Row(
                children: [
                  ConceptChip(label: 'Clair', active: app.themeMode == ThemeMode.light, onTap: () => app.setThemeMode(ThemeMode.light)),
                  const SizedBox(width: 8),
                  ConceptChip(label: 'Sombre', active: app.themeMode == ThemeMode.dark, onTap: () => app.setThemeMode(ThemeMode.dark)),
                  const SizedBox(width: 8),
                  ConceptChip(label: 'Système', active: app.themeMode == ThemeMode.system, onTap: () => app.setThemeMode(ThemeMode.system)),
                ],
              ),
            ),
            const SizedBox(height: 26),
            OutlineAppButton(
              label: 'Se déconnecter',
              onPressed: () {
                app.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PreferenceGroup extends StatelessWidget {
  final String label;
  final Widget child;
  const _PreferenceGroup({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: monoFont(size: 11, weight: FontWeight.w600, color: c.textFaint, letterSpacing: 0.8)),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}
