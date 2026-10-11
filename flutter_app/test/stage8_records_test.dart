import 'package:flutter_test/flutter_test.dart';
import 'package:herd_hub_sheep/features/medications/domain/medication_search.dart';
import 'package:herd_hub_sheep/features/quick_log/data/in_memory_care_repository.dart';
import 'package:herd_hub_sheep/features/quick_log/domain/care_records.dart';
import 'package:herd_hub_sheep/features/quick_log/domain/record_weight.dart';
import 'package:herd_hub_sheep/features/sheep/data/mock_sheep_directory_repository.dart';
import 'package:herd_hub_sheep/features/sheep/domain/sheep_record.dart';
import 'package:herd_hub_sheep/features/sheep/domain/update_sheep.dart';

void main() {
  group('BcsValidator', () {
    test('accepts valid half-point scores', () {
      expect(BcsValidator.isValid(1), isTrue);
      expect(BcsValidator.isValid(1.5), isTrue);
      expect(BcsValidator.isValid(3), isTrue);
      expect(BcsValidator.isValid(5), isTrue);
    });

    test('rejects out-of-range and non-half-point scores', () {
      expect(BcsValidator.isValid(0), isFalse);
      expect(BcsValidator.isValid(5.5), isFalse);
      expect(BcsValidator.isValid(2.3), isFalse);
    });
  });

  group('MedicationSearchService', () {
    final medications = InMemoryCareRepository().getMedications();

    test('filters by category', () {
      final result = MedicationSearchService.search(
        medications,
        category: MedicationCategory.antibiotic,
      );
      expect(result, isNotEmpty);
      expect(
        result.every((m) => m.category == MedicationCategory.antibiotic),
        isTrue,
      );
    });

    test('searches by name and active ingredient', () {
      final result = MedicationSearchService.search(
        medications,
        query: 'albendazole',
      );
      expect(result.any((m) => m.id == 'albendazole'), isTrue);
    });
  });

  group('UpdateSheepUseCase', () {
    final repository = MockSheepDirectoryRepository();
    final events = InMemoryCareRepository();
    var counter = 0;

    UpdateSheepUseCase useCase() => UpdateSheepUseCase(
      repository: repository,
      eventRepository: events,
      createId: () => 'audit-${counter++}',
    );

    test('valid update applies optional fields', () {
      final current = repository.getById('184')!;
      final updated = useCase()(
        current: current,
        tagNumber: '184',
        name: 'Fatima',
        eidRfid: '982000123456789',
        sex: SheepSex.ewe,
        breed: 'Awassi',
        birthDate: current.birthDate,
        birthDateUnknown: false,
        color: 'White',
        markings: 'Black spot',
        groupName: current.groupName,
        source: 'Local farm',
        purchaseDate: null,
        purchasePrice: null,
        notes: 'Healthy',
        occurredAt: DateTime(2026, 9, 30),
        recordedBy: 'Ahmed',
      );
      expect(updated.sheep.name, 'Fatima');
      expect(updated.sheep.color, 'White');
    });

    test('duplicate tag is rejected', () {
      final current = repository.getById('184')!;
      expect(
        () => useCase()(
          current: current,
          tagNumber: '209',
          name: null,
          eidRfid: null,
          sex: SheepSex.ewe,
          breed: current.breed,
          birthDate: current.birthDate,
          birthDateUnknown: false,
          color: null,
          markings: null,
          groupName: current.groupName,
          source: null,
          purchaseDate: null,
          purchasePrice: null,
          notes: '',
          occurredAt: DateTime(2026, 9, 30),
          recordedBy: 'Ahmed',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('important change creates an audit event', () {
      final current = repository.getById('311')!;
      final eventsBefore = events.getEvents().length;
      useCase()(
        current: current,
        tagNumber: '311',
        name: null,
        eidRfid: null,
        sex: SheepSex.ram,
        breed: 'Awassi',
        birthDate: current.birthDate,
        birthDateUnknown: false,
        color: null,
        markings: null,
        groupName: 'Rams',
        source: null,
        purchaseDate: null,
        purchasePrice: null,
        notes: '',
        occurredAt: DateTime(2026, 9, 30),
        recordedBy: 'Ahmed',
      );
      final newEvents = events.getEvents().whereType<IdentityChangeEvent>();
      expect(events.getEvents().length, greaterThan(eventsBefore));
      expect(
        newEvents.any((e) => e.field == 'breed' && e.oldValue == 'Najdi'),
        isTrue,
      );
    });
  });

  group('RecordWeightUseCase', () {
    test('records weight and validates BCS', () {
      final repository = InMemoryCareRepository();
      var counter = 0;
      final useCase = RecordWeightUseCase(
        repository: repository,
        createId: () => 'weight-${counter++}',
      );
      final result = useCase(
        sheepId: '184',
        weightKg: 61.5,
        occurredAt: DateTime(2026, 9, 30),
        recordedBy: 'Ahmed',
        method: 'scale',
        bcs: 2.5,
      );
      expect(result.weight.weightKg, 61.5);
      expect(result.bcs?.score, 2.5);
      expect(
        () => useCase(
          sheepId: '184',
          weightKg: 61.5,
          occurredAt: DateTime(2026, 9, 30),
          recordedBy: 'Ahmed',
          bcs: 5.5,
        ),
        throwsArgumentError,
      );
    });
  });
}
