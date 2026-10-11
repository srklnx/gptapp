import 'care_records.dart';
import 'care_repositories.dart';

/// Result of recording a weight (and optionally a BCS score at the same time).
class WeightRecordResult {
  const WeightRecordResult({required this.weight, this.bcs});

  final WeightEvent weight;
  final BcsEvent? bcs;
}

/// Records a weight measurement through a use case so widgets never touch the
/// repository directly.
class RecordWeightUseCase {
  const RecordWeightUseCase({required this.repository, required this.createId});

  final CareRepository repository;
  final String Function() createId;

  WeightRecordResult call({
    required String sheepId,
    required double weightKg,
    required DateTime occurredAt,
    required String recordedBy,
    String unit = 'kg',
    String? method,
    String notes = '',
    double? bcs,
  }) {
    if (!weightKg.isFinite || weightKg <= 0) {
      throw ArgumentError.value(weightKg, 'weightKg', 'Must be positive');
    }
    if (bcs != null && !_isValidBcs(bcs)) {
      throw ArgumentError.value(bcs, 'bcs', 'Must be 1 to 5 in 0.5 steps');
    }
    final weightEvent = WeightEvent(
      id: createId(),
      sheepId: sheepId,
      occurredAt: occurredAt,
      recordedBy: recordedBy,
      weightKg: weightKg,
      unit: unit,
      method: method,
      notes: notes,
    );
    repository.saveEvent(weightEvent);

    BcsEvent? bcsEvent;
    if (bcs != null) {
      bcsEvent = BcsEvent(
        id: createId(),
        sheepId: sheepId,
        occurredAt: occurredAt,
        recordedBy: recordedBy,
        score: bcs,
        notes: notes,
      );
      repository.saveEvent(bcsEvent);
    }

    return WeightRecordResult(weight: weightEvent, bcs: bcsEvent);
  }

  static bool _isValidBcs(double value) {
    if (value < 1 || value > 5) return false;
    final halfSteps = (value * 2).round();
    return (halfSteps - value * 2).abs() < 1e-9;
  }
}

/// Validates a Body Condition Score: 1–5 in half-point steps.
abstract final class BcsValidator {
  static bool isValid(double value) {
    if (value < 1 || value > 5) return false;
    final halfSteps = (value * 2).round();
    return (halfSteps - value * 2).abs() < 1e-9;
  }
}
