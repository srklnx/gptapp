import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'core/services/in_memory_repositories.dart';
import 'core/services/local_json_store.dart';
import 'features/quick_log/data/care_providers.dart';
import 'features/quick_log/data/in_memory_care_repository.dart';
import 'features/sync/data/sync_providers.dart';
import 'features/breeding/data/breeding_providers.dart';
import 'features/health/data/health_providers.dart';
import 'features/health/data/health_case_providers.dart';
import 'features/parasites/data/parasite_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = LocalJsonStore(await getApplicationSupportDirectory());
  final careRepository = InMemoryCareRepository(
    initialData: store.read('care.json'),
    persist: (snapshot) => store.write('care.json', snapshot),
  );
  final syncRepository = InMemorySyncRepository(
    initialState: store.read('sync.json'),
    onChanged: (snapshot) => store.write('sync.json', snapshot),
  );
  final breedingRepository = InMemoryBreedingRepository(
    initialData: store.read('breeding.json'),
    persist: (snapshot) => store.write('breeding.json', snapshot),
  );
  final healthRepository = InMemoryHealthObservationRepository(
    initialData: store.read('health.json'),
    persist: (snapshot) => store.write('health.json', snapshot),
  );
  final healthCaseRepository = InMemoryHealthCaseRepository(
    initialData: store.read('health_cases.json'),
    persist: (snapshot) => store.write('health_cases.json', snapshot),
  );
  final parasiteRepository = InMemoryParasiteRepository(
    initialData: store.read('parasite.json'),
    persist: (snapshot) => store.write('parasite.json', snapshot),
  );
  runApp(
    ProviderScope(
      overrides: [
        careRepositoryProvider.overrideWithValue(careRepository),
        syncRepositoryProvider.overrideWithValue(syncRepository),
        breedingRepositoryProvider.overrideWithValue(breedingRepository),
        healthRepositoryProvider.overrideWithValue(healthRepository),
        healthCaseRepositoryProvider.overrideWithValue(healthCaseRepository),
        parasiteRepositoryProvider.overrideWithValue(parasiteRepository),
      ],
      child: const HerdHubApp(),
    ),
  );
}
