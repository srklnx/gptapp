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
  testWidgets('edit sheep screen renders identity form', (tester) async {
    await _pump(tester);
    await _openProfile(tester);

    await tester.tap(find.byKey(const Key('edit-sheep')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('edit-sheep-page')), findsOneWidget);
    expect(find.byKey(const Key('edit-sheep-tag')), findsOneWidget);
    expect(find.byKey(const Key('edit-sheep-name')), findsOneWidget);
    expect(find.byKey(const Key('edit-sheep-breed')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('health observation flow reaches dynamic questions', (tester) async {
    await _pump(tester);
    await _openProfile(tester);

    await tester.tap(find.byKey(const Key('health-observation-from-profile')));
    await tester.pumpAndSettle();

    // Step 0: who.
    await tester.tap(find.byKey(const Key('health-next')));
    await tester.pumpAndSettle();

    // Step 1: symptoms.
    expect(find.text('What did you observe?'), findsOneWidget);
    await tester.tap(find.byKey(const Key('symptom-reduced_appetite')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('health-next')));
    await tester.pumpAndSettle();

    // Step 2: dynamic follow-up questions (appetite).
    expect(find.byKey(const Key('health-questions-step')), findsOneWidget);
    expect(find.text('How long?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('severe breathing triggers an urgent warning', (tester) async {
    await _pump(tester);
    await _openProfile(tester);

    await tester.tap(find.byKey(const Key('health-observation-from-profile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('health-next')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('symptom-difficulty_breathing')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('symptom-difficulty_breathing')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('health-next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('health-next')));
    await tester.pumpAndSettle();

    // Step 3: severity — choose severe.
    await tester.tap(find.text('Severe'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('health-next')));
    await tester.pumpAndSettle();

    // Step 4: summary with urgent warning.
    expect(find.byKey(const Key('health-summary-step')), findsOneWidget);
    expect(find.byKey(const Key('urgent-attention')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
