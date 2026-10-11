import 'health_observation.dart';

/// Detects when several sheep have similar recent observations, which may
/// indicate a flock-level problem rather than isolated cases.
abstract final class FlockOutbreakService {
  static const _window = Duration(days: 7);
  static const _minimumAffected = 2;

  /// Returns true when [count] sheep share a matching observation within the
  /// window. Symptom similarity is intentionally simple and conservative.
  static bool isOutbreak({
    required List<HealthObservation> observations,
    required DateTime now,
    int minimumAffected = _minimumAffected,
  }) {
    final recent = observations
        .where((o) => now.difference(o.occurredAt) <= _window)
        .toList();

    // Count the largest group of sheep sharing at least one symptom.
    final symptomSheepCounts = <String, Set<String>>{};
    for (final observation in recent) {
      for (final sheepId in observation.sheepIds) {
        for (final symptomId in observation.symptomIds) {
          symptomSheepCounts
              .putIfAbsent(symptomId, () => <String>{})
              .add(sheepId);
        }
      }
    }
    for (final sheepIds in symptomSheepCounts.values) {
      if (sheepIds.length >= minimumAffected) return true;
    }
    return false;
  }
}
