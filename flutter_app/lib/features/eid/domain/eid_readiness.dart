import '../../quick_log/domain/care_records.dart';
import '../../quick_log/domain/withdrawal_calculator.dart';
import '../../sheep/domain/sheep_record.dart';

class EidCriteria {
  const EidCriteria({
    this.minimumWeightKg = 40,
    this.minimumBcs = 2.5,
    this.maximumBcs = 4.5,
  });

  final double minimumWeightKg;
  final double minimumBcs;
  final double maximumBcs;
}

enum EidReadinessStatus {
  ready,
  underweight,
  lowBcs,
  highBcs,
  healthConcern,
  withdrawal,
}

class EidReadiness {
  const EidReadiness({
    required this.sheep,
    required this.weightKg,
    required this.bcs,
    required this.status,
    required this.withdrawal,
  });

  final SheepRecord sheep;
  final double weightKg;
  final double bcs;
  final EidReadinessStatus status;
  final WithdrawalSummary withdrawal;

  bool get clearForSale =>
      status == EidReadinessStatus.ready && !withdrawal.notClearForSale;
}

abstract final class EidReadinessCalculator {
  static EidReadiness calculate({
    required SheepRecord sheep,
    SheepHealthStatus? effectiveHealthStatus,
    required Iterable<FarmEvent> events,
    required WithdrawalSummary withdrawal,
    required EidCriteria criteria,
  }) {
    final animalEvents =
        events.where((event) => event.sheepId == sheep.id).toList()
          ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    final latestWeight = animalEvents.whereType<WeightEvent>().firstOrNull;
    final latestBcs = animalEvents.whereType<BcsEvent>().firstOrNull;
    final weight = latestWeight?.weightKg ?? sheep.weightKg;
    final bcs = latestBcs?.score ?? sheep.bcs;
    final healthStatus = effectiveHealthStatus ?? sheep.status;
    final status = withdrawal.notClearForSale
        ? EidReadinessStatus.withdrawal
        : healthStatus == SheepHealthStatus.attention ||
              healthStatus == SheepHealthStatus.urgent
        ? EidReadinessStatus.healthConcern
        : bcs < criteria.minimumBcs
        ? EidReadinessStatus.lowBcs
        : bcs > criteria.maximumBcs
        ? EidReadinessStatus.highBcs
        : weight < criteria.minimumWeightKg
        ? EidReadinessStatus.underweight
        : EidReadinessStatus.ready;
    return EidReadiness(
      sheep: sheep,
      weightKg: weight,
      bcs: bcs,
      status: status,
      withdrawal: withdrawal,
    );
  }
}
