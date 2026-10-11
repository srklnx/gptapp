import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'foundation_page.dart';
import 'app_shell.dart';
import '../features/flock/presentation/flock_page.dart';
import '../features/breeding/presentation/breeding_page.dart';
import '../features/eid/presentation/eid_page.dart';
import '../features/heat_stress/presentation/heat_stress_page.dart';
import '../features/groups/presentation/group_detail_page.dart';
import '../features/groups/presentation/groups_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/quick_log/presentation/treatment_entry_page.dart';
import '../features/sheep/presentation/sheep_profile_page.dart';
import '../features/sheep/presentation/edit_sheep_page.dart';
import '../features/sheep/presentation/weight_entry_page.dart';
import '../features/health/presentation/health_observation_page.dart';
import '../features/health/presentation/health_center_screen.dart';
import '../features/health/presentation/health_case_list_screen.dart';
import '../features/medications/presentation/medication_library_page.dart';
import '../features/parasites/presentation/parasite_management_screen.dart';
import '../features/parasites/presentation/famacha_entry_page.dart';
import '../features/parasites/presentation/fecal_test_entry_page.dart';
import '../features/parasites/presentation/deworming_flow_page.dart';
import '../features/sync/presentation/sync_center_page.dart';
import '../features/tasks/presentation/tasks_page.dart';
import 'route_paths.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: homeRoute,
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: homeRoute,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: flockRoute,
            builder: (context, state) => const FlockPage(),
            routes: [
              GoRoute(
                path: 'sheep/:id',
                name: 'sheep-profile',
                builder: (context, state) =>
                    SheepProfilePage(sheepId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: tasksRoute,
            builder: (context, state) => const TasksPage(),
          ),
          GoRoute(
            path: breedingRoute,
            builder: (context, state) => BreedingPage(
              initialSheepId: state.uri.queryParameters['sheepId'],
            ),
          ),
          GoRoute(
            path: heatStressRoute,
            builder: (context, state) => HeatStressPage(
              initialSheepId: state.uri.queryParameters['sheepId'],
            ),
          ),
          GoRoute(path: eidRoute, builder: (context, state) => const EidPage()),
          GoRoute(
            path: moreRoute,
            builder: (context, state) =>
                const FoundationPage(routePath: moreRoute),
          ),
          GoRoute(
            path: settingsRoute,
            builder: (context, state) =>
                const FoundationPage(routePath: settingsRoute),
          ),
          GoRoute(
            path: syncRoute,
            builder: (context, state) => const SyncCenterPage(),
          ),
          GoRoute(
            path: groupsRoute,
            builder: (context, state) => const GroupsPage(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    GroupDetailPage(groupId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: treatmentEntryRoute,
            builder: (context, state) => TreatmentEntryPage(
              initialSheepId: state.uri.queryParameters['sheepId'],
              initialMedicationId: state.uri.queryParameters['medicationId'],
              observationId: state.uri.queryParameters['observationId'],
            ),
          ),
          GoRoute(
            path: editSheepRoute,
            builder: (context, state) => EditSheepPage(
              sheepId: state.uri.queryParameters['sheepId'] ?? '',
            ),
          ),
          GoRoute(
            path: weightEntryRoute,
            builder: (context, state) => WeightEntryPage(
              sheepId: state.uri.queryParameters['sheepId'] ?? '',
            ),
          ),
          GoRoute(
            path: healthObservationRoute,
            builder: (context, state) => HealthObservationPage(
              initialSheepId: state.uri.queryParameters['sheepId'],
            ),
          ),
          GoRoute(
            path: medicationLibraryRoute,
            builder: (context, state) => MedicationLibraryPage(
              sheepId: state.uri.queryParameters['sheepId'],
              observationId: state.uri.queryParameters['observationId'],
            ),
          ),
          GoRoute(
            path: healthCenterRoute,
            builder: (context, state) => HealthCenterScreen(
              sheepId: state.uri.queryParameters['sheepId'] ?? '',
            ),
          ),
          GoRoute(
            path: healthCaseListRoute,
            builder: (context, state) => HealthCaseListScreen(
              sheepId: state.uri.queryParameters['sheepId'] ?? '',
            ),
          ),
          GoRoute(
            path: parasiteManagementRoute,
            builder: (context, state) => ParasiteManagementScreen(
              sheepId: state.uri.queryParameters['sheepId'] ?? '',
            ),
          ),
          GoRoute(
            path: famachaEntryRoute,
            builder: (context, state) => FamachaEntryPage(
              sheepId: state.uri.queryParameters['sheepId'] ?? '',
            ),
          ),
          GoRoute(
            path: fecalTestEntryRoute,
            builder: (context, state) => FecalTestEntryPage(
              sheepId: state.uri.queryParameters['sheepId'] ?? '',
            ),
          ),
          GoRoute(
            path: dewormingRoute,
            builder: (context, state) => DewormingFlowPage(
              sheepId: state.uri.queryParameters['sheepId'] ?? '',
            ),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
