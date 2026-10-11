import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:herd_hub_sheep/app/app.dart';

Future<void> _pump(WidgetTester tester) async {
  tester.view.physicalSize = const Size(412, 915);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const ProviderScope(child: HerdHubApp()));
  await tester.pumpAndSettle();
}

Future<void> _openProfile(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('nav-flock')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('sheep-card-184')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'full health assessment renders conditions and no crash',
    (tester) async {
      await _pump(tester);
      await _openProfile(tester);

      await tester.tap(find.byKey(const Key('health-observation-from-profile')));
      await tester.pumpAndSettle();

      // Step 0: who.
      await tester.tap(find.byKey(const Key('health-next')));
      await tester.pumpAndSettle();

      // Step 1: symptoms (reduced appetite + diarrhea are both visible).
      await tester.tap(find.byKey(const Key('symptom-reduced_appetite')));
      await tester.tap(find.byKey(const Key('symptom-diarrhea')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('health-next')));
      await tester.pumpAndSettle();

      // Step 2: dynamic questions (appetite + diarrhea + risk factors).
      expect(find.byKey(const Key('health-questions-step')), findsOneWidget);
      await tester.tap(find.byKey(const Key('health-next')));
      await tester.pumpAndSettle();

      // Step 3: severity.
      await tester.tap(find.byKey(const Key('health-next')));
      await tester.pumpAndSettle();

      // Step 4: summary with assessment.
      expect(find.byKey(const Key('health-summary-step')), findsOneWidget);
      expect(find.text('Conditions to consider'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('health assessment renders in Arabic RTL without overflow', (
    tester,
  ) async {
    await _pump(tester);
    await tester.tap(find.byKey(const Key('locale-toggle')));
    await tester.pumpAndSettle();
    await _openProfile(tester);

    await tester.tap(find.byKey(const Key('health-observation-from-profile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('health-next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('symptom-reduced_appetite')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('health-next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('health-next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('health-next')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('health-summary-step')), findsOneWidget);
    expect(find.text('حالات يجب التفكير فيها'), findsOneWidget);
  });
}
