import '../../quick_log/domain/care_records.dart';

/// Searches and filters the medication library.
///
/// The library stores structured product information only; it never asserts a
/// universal dose or a guaranteed treatment.
abstract final class MedicationSearchService {
  static List<MedicationRecord> search(
    Iterable<MedicationRecord> medications, {
    String query = '',
    MedicationCategory? category,
    TreatmentRoute? route,
  }) {
    final normalized = query.trim().toLowerCase();
    final results = medications.where((medication) {
      if (!medication.active) return false;
      if (category != null && medication.category != category) return false;
      if (route != null && !medication.routeOptions.contains(route)) {
        return false;
      }
      if (normalized.isEmpty) return true;
      return medication.name.toLowerCase().contains(normalized) ||
          medication.activeIngredient.toLowerCase().contains(normalized);
    }).toList();
    return List.unmodifiable(results);
  }
}
