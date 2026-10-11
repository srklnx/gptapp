import 'care_records.dart';

enum WithdrawalState { clear, active }

class WithdrawalClearanceDates {
  const WithdrawalClearanceDates({required this.meat, required this.milk});

  final DateTime meat;
  final DateTime milk;
}

class WithdrawalSummary {
  const WithdrawalSummary({
    required this.meatClearanceDate,
    required this.milkClearanceDate,
    required this.meatState,
    required this.milkState,
  });

  final DateTime? meatClearanceDate;
  final DateTime? milkClearanceDate;
  final WithdrawalState meatState;
  final WithdrawalState milkState;

  bool get notClearForSale => meatState == WithdrawalState.active;
  bool get hasAnyActiveWithdrawal =>
      meatState == WithdrawalState.active ||
      milkState == WithdrawalState.active;

  int? daysUntilMeatClearance(DateTime now) {
    final clearance = meatClearanceDate;
    if (clearance == null || meatState == WithdrawalState.clear) return null;
    return _remainingDays(clearance, now);
  }

  int? daysUntilMilkClearance(DateTime now) {
    final clearance = milkClearanceDate;
    if (clearance == null || milkState == WithdrawalState.clear) return null;
    return _remainingDays(clearance, now);
  }

  static int _remainingDays(DateTime clearance, DateTime now) =>
      (clearance.difference(now).inSeconds + Duration.secondsPerDay - 1) ~/
      Duration.secondsPerDay;
}

abstract final class WithdrawalCalculator {
  static WithdrawalClearanceDates clearanceDatesFor(
    MedicationRecord medication,
    DateTime administeredAt,
  ) => WithdrawalClearanceDates(
    meat: administeredAt.add(Duration(days: medication.meatWithdrawalDays)),
    milk: administeredAt.add(Duration(days: medication.milkWithdrawalDays)),
  );

  static WithdrawalSummary calculate(
    Iterable<TreatmentRecord> treatments, {
    required DateTime now,
  }) {
    DateTime? latestMeatClearance;
    DateTime? latestMilkClearance;

    for (final treatment in treatments) {
      if (treatment.clearanceDate.isAfter(now) &&
          (latestMeatClearance == null ||
              treatment.clearanceDate.isAfter(latestMeatClearance))) {
        latestMeatClearance = treatment.clearanceDate;
      }
      if (treatment.milkClearanceDate.isAfter(now) &&
          (latestMilkClearance == null ||
              treatment.milkClearanceDate.isAfter(latestMilkClearance))) {
        latestMilkClearance = treatment.milkClearanceDate;
      }
    }

    return WithdrawalSummary(
      meatClearanceDate: latestMeatClearance,
      milkClearanceDate: latestMilkClearance,
      meatState: latestMeatClearance == null
          ? WithdrawalState.clear
          : WithdrawalState.active,
      milkState: latestMilkClearance == null
          ? WithdrawalState.clear
          : WithdrawalState.active,
    );
  }
}
