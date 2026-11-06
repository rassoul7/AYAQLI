import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/mini_player.dart';
import 'learning_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final app = context.watch<AppState>();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: app.currentTab.index,
          children: const [SearchScreen(), LearningScreen(), ProfileScreen()],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MiniPlayer(),
            Container(
              height: 62,
              decoration: BoxDecoration(color: c.bg, border: Border(top: BorderSide(color: c.border))),
              child: Row(
                children: [
                  _TabItem(tab: AppTab.search, icon: Icons.search, label: 'Rechercher'),
                  _TabItem(tab: AppTab.learn, icon: Icons.school_outlined, label: 'Apprendre'),
                  _TabItem(tab: AppTab.profile, icon: Icons.person_outline, label: 'Profil'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final AppTab tab;
  final IconData icon;
  final String label;

  const _TabItem({required this.tab, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final app = context.watch<AppState>();
    final active = app.currentTab == tab;
    final color = active ? c.primary : c.textFaint;

    return Expanded(
      child: GestureDetector(
        onTap: () => app.setTab(tab),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(label, style: latinFont(size: 10, weight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}
