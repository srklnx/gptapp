import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:herd_hub_sheep/app/app.dart';
import 'package:herd_hub_sheep/app/app_settings.dart';
import 'package:herd_hub_sheep/app/theme/app_theme_extension.dart';
import 'package:herd_hub_sheep/core/errors/repository_exception.dart';
import 'package:herd_hub_sheep/core/models/entities.dart';
import 'package:herd_hub_sheep/core/services/in_memory_repositories.dart';
import 'package:herd_hub_sheep/features/quick_log/data/care_providers.dart';
import 'package:herd_hub_sheep/features/sync/data/sync_providers.dart';

Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: HerdHubApp()));
  await tester.pumpAndSettle();
}

Future<void> scrollTo(WidgetTester tester, Finder item) async {
  final list = _verticalScrollables(find.byKey(const Key('flock-page'))).first;
  await tester.scrollUntilVisible(item, 420, scrollable: list);
  await tester.pumpAndSettle();
}

Finder _verticalScrollables(Finder ancestor) => find.descendant(
  of: ancestor,
  matching: find.byWidgetPredicate(
    (widget) =>
        widget is Scrollable && widget.axisDirection == AxisDirection.down,
  ),
);

void main() {
  testWidgets('home presents farm priorities, tasks and flock snapshot', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.byKey(const Key('home-page')), findsOneWidget);
    expect(find.text('Al Noor Farm'), findsOneWidget);
    expect(find.text('43°C'), findsOneWidget);
    expect(find.text('HEAT RISK · HIGH'), findsWidgets);
    expect(find.text('Offline · Changes saved locally'), findsOneWidget);
    expect(find.text('12 pending'), findsOneWidget);
    expect(find.text('Needs attention'), findsOneWidget);
    final homeScroll = _verticalScrollables(find.byKey(const Key('home-page')))
        .first;
    await tester.scrollUntilVisible(
      find.text('Vaccinate Pregnant Ewes'),
      260,
      scrollable: homeScroll,
    );
    expect(find.text('Vaccinate Pregnant Ewes'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Flock snapshot'),
      260,
      scrollable: homeScroll,
    );
    expect(find.text('Flock snapshot'), findsOneWidget);
  });

  testWidgets('flock renders cards and supports query and saved filters', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const Key('nav-flock')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('flock-page')), findsOneWidget);
    expect(find.byKey(const Key('flock-search')), findsOneWidget);
    expect(find.byKey(const Key('scan-tag')), findsOneWidget);
    expect(find.byKey(const Key('add-sheep')), findsOneWidget);
    expect(find.text('Due for Vaccination'), findsOneWidget);
    expect(find.text('Withdrawal Active'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('flock-search')), '184');
    await tester.pumpAndSettle();
    await scrollTo(tester, find.byKey(const Key('sheep-card-184')));
    expect(find.byKey(const Key('sheep-card-184')), findsOneWidget);
    expect(find.text('#209'), findsNothing);

    await tester.drag(
      _verticalScrollables(find.byKey(const Key('flock-page'))).first,
      const Offset(0, 1200),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('clear-flock-search')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ewes').first);
    await tester.pumpAndSettle();
    await scrollTo(tester, find.byKey(const Key('sheep-card-184')));
    expect(find.byKey(const Key('sheep-card-184')), findsOneWidget);
  });

  testWidgets(
    'SheepCard opens parameterized profile and back returns to flock',
    (tester) async {
      await pumpApp(tester);
      await tester.tap(find.byKey(const Key('nav-flock')));
      await tester.pumpAndSettle();
      await scrollTo(tester, find.byKey(const Key('sheep-card-184')));

      expect(find.textContaining('62.4 kg'), findsWidgets);
      expect(find.textContaining('2.5'), findsWidgets);
      await tester.tap(find.byKey(const Key('sheep-card-184')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('sheep-profile-184')), findsOneWidget);
      expect(find.text('#184'), findsWidgets);
      expect(find.text('Identity'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Recent activity'),
        200,
        scrollable: _verticalScrollables(
          find.byKey(const Key('sheep-profile-184')),
        ).first,
      );
      expect(find.text('Recent activity'), findsOneWidget);

      await tester.tap(find.byKey(const Key('profile-back')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('flock-page')), findsOneWidget);
    },
  );

  testWidgets('profile tabs show Health, Breeding, Weight and Timeline', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const Key('nav-flock')));
    await tester.pumpAndSettle();
    await scrollTo(tester, find.byKey(const Key('sheep-card-184')));
    await tester.tap(find.byKey(const Key('sheep-card-184')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('profile-tab-health')));
    await tester.pumpAndSettle();
    expect(find.text('Health routines'), findsOneWidget);
    await tester.tap(find.byKey(const Key('profile-tab-breeding')));
    await tester.pumpAndSettle();
    expect(find.text('Breeding status'), findsOneWidget);
    await tester.tap(find.byKey(const Key('profile-tab-timeline')));
    await tester.pumpAndSettle();
    final profileScroll = _verticalScrollables(
      find.byKey(const Key('sheep-profile-184')),
    );
    await tester.scrollUntilVisible(
      find.text('Vaccination · Clostridial'),
      250,
      scrollable: profileScroll.first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Vaccination · Clostridial'), findsOneWidget);
  });

  testWidgets('bottom navigation opens the field-friendly Quick Log', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const Key('nav-tasks')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('tasks-today')), findsOneWidget);
    expect(find.text('Vaccinate Pregnant Ewes'), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-quick-log')));
    await tester.pumpAndSettle();
    expect(find.text('What do you want to record?'), findsOneWidget);
    expect(find.text('Health'), findsOneWidget);
    expect(find.text('Condition'), findsOneWidget);
    expect(find.byKey(const Key('quick-action-treatment')), findsOneWidget);
  });

  testWidgets('treatment save updates profile, timeline and home alert', (
    tester,
  ) async {
    await pumpApp(tester);
    GoRouter.of(tester.element(find.byKey(const Key('home-page'))))
        .go('/flock/sheep/311');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sheep-profile-311')), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-quick-log')));
    await tester.pumpAndSettle();
    expect(find.text('What do you want to record?'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('quick-action-treatment')),
      100,
      scrollable: _verticalScrollables(find.byKey(const Key('quick-log-sheet')))
          .first,
    );
    await tester.tap(find.byKey(const Key('quick-action-treatment')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('treatment-entry-page')), findsOneWidget);
    expect(find.text('Treatment for #311'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('save-treatment')),
      150,
      scrollable: _verticalScrollables(
        find.byKey(const Key('treatment-entry-page')),
      ).first,
    );
    await tester.tap(find.byKey(const Key('save-treatment')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('treatment-confirmation')), findsOneWidget);
    expect(find.text('Saved locally · Waiting to sync'), findsOneWidget);
    expect(find.text('Follow-up task created'), findsOneWidget);
    final container = ProviderScope.containerOf(
      tester.element(find.byKey(const Key('treatment-confirmation'))),
      listen: false,
    );
    final treatment = container.read(careProvider).treatmentsFor('311').single;
    expect(
      container
          .read(syncCenterProvider)
          .items
          .where((item) => item.entityId == treatment.id),
      hasLength(1),
    );
    expect(
      container
          .read(syncCenterProvider)
          .items
          .where((item) => item.idempotencyKey.startsWith('event:care-')),
      isNotEmpty,
    );

    await tester.tap(find.byKey(const Key('profile-back')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('profile-tab-health')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('NOT CLEAR FOR SALE'),
      180,
      scrollable: _verticalScrollables(
        find.byKey(const Key('sheep-profile-311')),
      ).first,
    );
    expect(find.text('NOT CLEAR FOR SALE'), findsOneWidget);
    expect(find.text('Albendazole'), findsOneWidget);

    await tester.tap(find.byKey(const Key('profile-tab-timeline')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Treatment · Albendazole'),
      180,
      scrollable: _verticalScrollables(
        find.byKey(const Key('sheep-profile-311')),
      ).first,
    );
    expect(find.text('Treatment · Albendazole'), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-home')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-withdrawal-alert')), findsOneWidget);
    expect(find.textContaining('#311'), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-flock')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eid Candidates'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sheep-card-311')), findsNothing);
    await tester.tap(find.text('Withdrawal').first);
    await tester.pumpAndSettle();
    await scrollTo(tester, find.byKey(const Key('sheep-card-311')));
    expect(find.byKey(const Key('sheep-card-311')), findsOneWidget);

    container.read(appSettingsProvider.notifier).setOnline(true);
    await tester.runAsync(
      () => container.read(syncCenterProvider.notifier).syncNow(),
    );
    expect(
      container
          .read(syncCenterProvider)
          .items
          .where(
            (item) =>
                item.entityId == treatment.id &&
                item.status == SyncStatus.synced,
          ),
      hasLength(1),
    );
    expect(container.read(careProvider).treatmentsFor('311'), hasLength(1));
  });

  testWidgets('light, dark, and sun themes are applied', (tester) async {
    await pumpApp(tester);
    var theme = Theme.of(tester.element(find.byKey(const Key('home-page'))));
    expect(theme.brightness, Brightness.light);

    await tester.tap(find.byKey(const Key('theme-toggle')));
    await tester.pumpAndSettle();
    theme = Theme.of(tester.element(find.byKey(const Key('home-page'))));
    expect(theme.brightness, Brightness.dark);

    await tester.tap(find.byKey(const Key('theme-toggle')));
    await tester.pumpAndSettle();
    theme = Theme.of(tester.element(find.byKey(const Key('home-page'))));
    expect(theme.scaffoldBackgroundColor, Colors.white);
    expect(theme.extension<AppFieldSettings>()!.minimumTouchTarget, 56);
  });

  testWidgets('Arabic Home and Flock localize and use RTL direction', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const Key('locale-toggle')));
    await tester.pumpAndSettle();

    expect(find.text('مزرعة النور'), findsOneWidget);
    expect(find.text('يحتاج إلى متابعة'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byKey(const Key('home-page')))),
      TextDirection.rtl,
    );

    await tester.tap(find.byKey(const Key('nav-flock')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('flock-page')), findsOneWidget);
    expect(
      find.text('ابحث برقم الشارة أو المجموعة أو السلالة'),
      findsOneWidget,
    );
    expect(
      Directionality.of(tester.element(find.byKey(const Key('flock-page')))),
      TextDirection.rtl,
    );

    await tester.tap(find.byKey(const Key('nav-quick-log')));
    await tester.pumpAndSettle();
    expect(find.text('ما الذي تريد تسجيله؟'), findsOneWidget);
    expect(
      Directionality.of(
        tester.element(find.byKey(const Key('quick-log-sheet'))),
      ),
      TextDirection.rtl,
    );
  });

  testWidgets(
    'Arabic Home, Flock, Profile, Quick Log, Tasks and Sync Center fit RTL',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 720);
      await pumpApp(tester);
      await tester.tap(find.byKey(const Key('locale-toggle')));
      await tester.pumpAndSettle();

      expect(
        Directionality.of(tester.element(find.byKey(const Key('home-page')))),
        TextDirection.rtl,
      );
      expect(find.text('خطر الإجهاد الحراري · مرتفع'), findsWidgets);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byKey(const Key('nav-flock')));
      await tester.pumpAndSettle();
      expect(
        Directionality.of(tester.element(find.byKey(const Key('flock-page')))),
        TextDirection.rtl,
      );
      expect(
        find.text('ابحث برقم الشارة أو المجموعة أو السلالة'),
        findsOneWidget,
      );
      await tester.enterText(find.byKey(const Key('flock-search')), '184');
      await tester.pumpAndSettle();
      final sheepCard = find.byKey(const Key('sheep-card-184'));
      await scrollTo(tester, sheepCard);
      expect(sheepCard, findsOneWidget);
      expect(
        tester
            .widgetList<Icon>(
              find.descendant(of: sheepCard, matching: find.byType(Icon)),
            )
            .any((icon) => icon.icon == Icons.chevron_left),
        isTrue,
      );
      expect(tester.takeException(), isNull);

      await tester.tap(sheepCard);
      await tester.pumpAndSettle();
      final profile = find.byKey(const Key('sheep-profile-184'));
      expect(Directionality.of(tester.element(profile)), TextDirection.rtl);
      await tester.scrollUntilVisible(
        find.text('الهوية'),
        180,
        scrollable: _verticalScrollables(profile).first,
      );
      expect(find.text('الهوية'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('nav-quick-log')));
      await tester.pumpAndSettle();
      final quickLog = find.byKey(const Key('quick-log-sheet'));
      expect(Directionality.of(tester.element(quickLog)), TextDirection.rtl);
      expect(find.text('العلاج'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('nav-tasks')));
      await tester.pumpAndSettle();
      expect(
        Directionality.of(tester.element(find.byKey(const Key('tasks-today')))),
        TextDirection.rtl,
      );
      expect(find.text('المهام'), findsWidgets);
      expect(tester.takeException(), isNull);

      GoRouter.of(tester.element(find.byKey(const Key('tasks-today'))))
          .go('/sync');
      await tester.pumpAndSettle();
      expect(
        Directionality.of(
          tester.element(find.byKey(const Key('sync-center-page'))),
        ),
        TextDirection.rtl,
      );
      expect(find.textContaining('بانتظار المزامنة'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('numeral and calendar settings change displayed profile dates', (
    tester,
  ) async {
    await pumpApp(tester);
    GoRouter.of(tester.element(find.byKey(const Key('home-page'))))
        .go('/settings');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('locale-toggle')));
    await tester.pumpAndSettle();

    final settingsScroll = _verticalScrollables(
      find.byKey(const Key('route-/settings')),
    ).first;
    await tester.scrollUntilVisible(
      find.text('الأرقام العربية الهندية (١٢٣)'),
      200,
      scrollable: settingsScroll,
    );
    await tester.tap(find.text('الأرقام العربية الهندية (١٢٣)'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('هجري حسابي'),
      200,
      scrollable: settingsScroll,
    );
    await tester.tap(find.text('هجري حسابي'));
    await tester.pumpAndSettle();
    GoRouter.of(tester.element(find.byKey(const Key('route-/settings'))))
        .go('/flock/sheep/184');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('profile-tab-health')));
    await tester.pumpAndSettle();
    expect(find.textContaining('هـ'), findsWidgets);
    expect(find.text('#١٨٤'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home and Flock fit small, normal, and large phone widths', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;

    for (final size in [
      const Size(320, 640),
      const Size(393, 852),
      const Size(430, 932),
    ]) {
      tester.view.physicalSize = size;
      await pumpApp(tester);
      expect(tester.takeException(), isNull, reason: 'Home at $size');
      await tester.tap(find.byKey(const Key('nav-flock')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Flock at $size');
    }
  });

  testWidgets('More links keep the foundation settings and sync routes', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const Key('nav-more')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open Settings'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('route-/settings')), findsOneWidget);
    expect(find.text('Sun Mode'), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-more')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open Sync Center'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sync-center-page')), findsOneWidget);
  });

  testWidgets('Sync Center shows offline state and runs simulated sync', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const Key('nav-more')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open Sync Center'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('sync-center-page')), findsOneWidget);
    expect(find.text('Offline'), findsWidgets);
    final syncButton = tester.widget<FilledButton>(
      find.byKey(const Key('sync-now')),
    );
    expect(syncButton.onPressed, isNull);
    expect(find.textContaining('12 Pending'), findsWidgets);

    await tester.tap(find.text('Online').last);
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byKey(const Key('sync-center-page'))),
      listen: false,
    );
    await tester.runAsync(
      () => container.read(syncCenterProvider.notifier).syncNow(),
    );
    await tester.pumpAndSettle();

    expect(container.read(syncCenterProvider).count(SyncStatus.pending), 0);
    expect(container.read(syncCenterProvider).count(SyncStatus.synced), 20);
  });

  test(
    'sheep visual tag and RFID are separate; duplicate tags are farm scoped',
    () async {
      final repository = InMemorySheepRepository();
      final now = DateTime.utc(2026, 9, 30);
      final first = Sheep(
        id: 'sheep-1',
        createdAt: now,
        updatedAt: now,
        farmId: 'farm-1',
        tagNumber: '184',
        eidRfid: '982000123456789',
      );
      await repository.save(first);
      expect((await repository.getById('sheep-1'))!.tagNumber, '184');
      expect((await repository.getById('sheep-1'))!.eidRfid, '982000123456789');
      expect(await repository.findByTagNumber('farm-1', '184'), same(first));

      await expectLater(
        repository.save(
          Sheep(
            id: 'sheep-2',
            createdAt: now,
            updatedAt: now,
            farmId: 'farm-1',
            tagNumber: '184',
          ),
        ),
        throwsA(isA<DuplicateSheepTagException>()),
      );
      await repository.save(
        Sheep(
          id: 'sheep-3',
          createdAt: now,
          updatedAt: now,
          farmId: 'farm-2',
          tagNumber: '184',
        ),
      );
      expect(await repository.findByTagNumber('farm-2', '184'), isNotNull);
    },
  );
}
