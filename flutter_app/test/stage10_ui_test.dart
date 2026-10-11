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
  testWidgets('Health Center renders with derived status', (tester) async {
    await _pump(tester);
    await _openProfile(tester);
    await tester.tap(find.byKey(const Key('health-center-from-profile')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('health-center-screen')), findsOneWidget);
    expect(find.textContaining('Current status'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Parasite Management renders with actions and empty states', (
    tester,
  ) async {
    await _pump(tester);
    await _openProfile(tester);
    await tester.tap(find.byKey(const Key('parasites-from-profile')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('parasite-management-screen')), findsOneWidget);
    expect(find.byKey(const Key('parasite-deworm')), findsOneWidget);
    expect(find.text('No FAMACHA recorded'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Deworming flow asks why before medication', (tester) async {
    await _pump(tester);
    await _openProfile(tester);
    await tester.tap(find.byKey(const Key('parasites-from-profile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('parasite-deworm')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('deworming-flow-page')), findsOneWidget);
    expect(find.text('Why are you deworming?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
