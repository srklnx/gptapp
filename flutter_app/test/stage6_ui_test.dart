import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:herd_hub_sheep/app/app.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(412, 915);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const ProviderScope(child: HerdHubApp()));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('nav-more')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('breeding dashboard shows records and recording actions', (
    tester,
  ) async {
    await _pumpApp(tester);
    await tester.tap(find.text('Open Breeding'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('breeding-page')), findsOneWidget);
    expect(find.text('Upcoming lambings'), findsOneWidget);
    expect(find.byKey(const Key('record-mating')), findsOneWidget);
    expect(find.byKey(const Key('record-pregnancy')), findsOneWidget);
    expect(find.byKey(const Key('record-lambing')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('heat stress page can be opened and shows recommendations', (
    tester,
  ) async {
    await _pumpApp(tester);
    await tester.tap(find.byKey(const Key('nav-quick-log')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('quick-action-heat check')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('heat-stress-page')), findsOneWidget);
    expect(find.text('Conditions'), findsOneWidget);
    final heatScroll = find
        .descendant(
          of: find.byKey(const Key('heat-stress-page')),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Scrollable &&
                widget.axisDirection == AxisDirection.down,
          ),
        )
        .first;
    await tester.scrollUntilVisible(
      find.text('Move to shade'),
      280,
      scrollable: heatScroll,
    );
    expect(find.text('Move to shade'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('record-heat-check')),
      240,
      scrollable: heatScroll,
    );
    expect(find.byKey(const Key('record-heat-check')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Quick Log mating carries selected sheep into the breeding form',
    (tester) async {
      await _pumpApp(tester);
      await tester.tap(find.byKey(const Key('nav-quick-log')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('quick-action-mating')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('breeding-page')), findsOneWidget);
      await tester.tap(find.byKey(const Key('record-mating')));
      await tester.pumpAndSettle();
      expect(find.text('#184 · Awassi'), findsOneWidget);
      await tester.enterText(find.byType(TextField).last, 'R12');
      await tester.tap(find.text('Save record'));
      await tester.pumpAndSettle();
      final breedingScroll = find
          .descendant(
            of: find.byKey(const Key('breeding-page')),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is Scrollable &&
                  widget.axisDirection == AxisDirection.down,
            ),
          )
          .first;
      await tester.scrollUntilVisible(
        find.text('Recent matings'),
        240,
        scrollable: breedingScroll,
      );
      expect(find.text('Recent matings'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Eid readiness page opens with derived candidate list', (
    tester,
  ) async {
    await _pumpApp(tester);
    await tester.tap(find.text('Open Eid mode'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('eid-page')), findsOneWidget);
    expect(find.text('Eid al-Adha countdown'), findsOneWidget);
    expect(find.textContaining('CLEAR FOR SALE'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('heat stress screen renders with Arabic RTL localization', (
    tester,
  ) async {
    await _pumpApp(tester);
    await tester.tap(find.byKey(const Key('locale-toggle')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('فتح الإجهاد الحراري'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('heat-stress-page')), findsOneWidget);
    expect(find.text('الإجهاد الحراري'), findsWidgets);
    expect(
      Directionality.of(
        tester.element(find.byKey(const Key('heat-stress-page'))),
      ),
      TextDirection.rtl,
    );
    expect(tester.takeException(), isNull);
  });
}
