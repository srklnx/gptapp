import 'care_records.dart';
import 'care_repositories.dart';
import 'withdrawal_calculator.dart';

class RecordTreatment {
  const RecordTreatment({required this.repository, required this.createId});

  final CareRepository repository;
  final String Function() createId;

  TreatmentRecord call({
    required String sheepId,
    required MedicationRecord medication,
    required double dose,
    required DateTime administeredAt,
    required String administeredBy,
    String notes = '',
    String? observationId,
    String? eventId,
    String treatmentReason = '',
  }) {
    if (!dose.isFinite || dose <= 0) {
      throw ArgumentError.value(dose, 'dose', 'Must be a positive number');
    }
    final clearance = WithdrawalCalculator.clearanceDatesFor(
      medication,
      administeredAt,
    );
    final treatmentId = createId();
    final now = DateTime.now();
    final treatment = TreatmentRecord(
      id: treatmentId,
      sheepId: sheepId,
      medicationId: medication.id,
      dose: dose,
      doseUnit: medication.doseUnit,
      route: medication.route,
      administeredAt: administeredAt,
      administeredBy: administeredBy,
      withdrawalDays: medication.meatWithdrawalDays,
      milkWithdrawalDays: medication.milkWithdrawalDays,
      clearanceDate: clearance.meat,
      milkClearanceDate: clearance.milk,
      notes: notes,
      medicationNameSnapshot: medication.name,
      activeIngredientSnapshot: medication.activeIngredient,
      observationId: observationId,
      eventId: eventId,
      createdAt: now,
      updatedAt: now,
      treatmentReason: treatmentReason,
    );
    repository.saveTreatment(treatment);
    repository.saveEvent(
      TreatmentEvent(
        id: createId(),
        sheepId: sheepId,
        occurredAt: administeredAt,
        recordedBy: administeredBy,
        treatmentId: treatmentId,
        medicationName: medication.name,
        dose: dose,
        doseUnit: medication.doseUnit,
      ),
    );
    final followUpDays = medication.followUpAfterDays;
    if (followUpDays != null) {
      repository.saveFollowUpTask(
        FollowUpTask(
          id: createId(),
          sheepId: sheepId,
          title: 'Treatment follow-up · ${medication.name}',
          dueAt: administeredAt.add(Duration(days: followUpDays)),
          createdAt: administeredAt,
        ),
      );
    }
    return treatment;
  }
}
