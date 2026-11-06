import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:ayaqli/main.dart';
import 'package:ayaqli/state/app_state.dart';

void main() {
  testWidgets('Auth screen loads with the Ayaqli wordmark and continue options', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const AyaqliApp(),
      ),
    );

    expect(find.text('Ayaqli'), findsOneWidget);
    expect(find.text("Continuer en tant qu'invité"), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
