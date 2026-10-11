import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herd_hub_sheep/app/app.dart';

void main() {
  testWidgets(
    'primary navigation exposes a labeled field-size Quick Log target',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const ProviderScope(child: HerdHubApp()));
      await tester.pumpAndSettle();

      final quickLog = find.byKey(const Key('nav-quick-log'));
      expect(tester.getSize(quickLog).height, greaterThanOrEqualTo(48));
      final semantics = tester.ensureSemantics();
      final node = tester.getSemantics(quickLog);
      expect(node.label, 'Quick Log');
      expect(node.getSemanticsData().flagsCollection.isButton, isTrue);
      semantics.dispose();

      await tester.tap(quickLog);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('quick-log-sheet')), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('empty flock search gives a clear recovery state in RTL', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: HerdHubApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('locale-toggle')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-flock')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('flock-search')), 'no-match');
    await tester.pumpAndSettle();

    expect(find.text('لم يتم العثور على أغنام'), findsOneWidget);
    expect(find.text('جرّب بحثاً أو مرشحاً آخر.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adding a sheep saves it to the flock and opens its profile', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: HerdHubApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-flock')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('add-sheep')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('new-sheep-tag')), '901');
    await tester.tap(find.byKey(const Key('new-sheep-breed')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Awassi').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('new-sheep-weight')), '54.2');
    await tester.tap(find.byKey(const Key('save-new-sheep')));
    await tester.pumpAndSettle();

    expect(find.text('#901'), findsWidgets);
    await tester.tap(find.byKey(const Key('profile-back')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('flock-search')), '901');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sheep-card-901')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'flock remains usable with increased operating-system text size',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      tester.view.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(
        tester.binding.platformDispatcher.clearTextScaleFactorTestValue,
      );
      await tester.pumpWidget(const ProviderScope(child: HerdHubApp()));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('nav-flock')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('flock-search')), findsOneWidget);
      expect(find.byKey(const Key('add-sheep')), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
