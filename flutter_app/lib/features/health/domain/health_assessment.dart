import 'package:flutter/foundation.dart';

import 'condition.dart';
import 'condition_rule_engine.dart';
import 'health_observation.dart';
import 'treatment_protocol.dart';

/// A treatment pathway surfaced for a candidate condition.
@immutable
class TreatmentPathway {
  const TreatmentPathway({required this.conditionId, required this.protocol});

  final String conditionId;
  final TreatmentProtocol protocol;
}

/// The structured result shown after a health observation.
@immutable
class HealthAssessment {
  const HealthAssessment({
    required this.riskLevel,
    required this.candidates,
    required this.urgentFlags,
    required this.immediateActions,
    required this.pathways,
    required this.flockOutbreak,
    required this.antibioticNotAutomaticallyIndicated,
  });

  final HealthRiskLevel riskLevel;
  final List<ConditionCandidate> candidates;
  final List<String> urgentFlags;
  final List<String> immediateActions;
  final List<TreatmentPathway> pathways;
  final bool flockOutbreak;
  final bool antibioticNotAutomaticallyIndicated;
}

/// Builds a structured, explainable health assessment from observations.
///
/// It does NOT contain clinical "if symptom then drug" logic; it delegates to
/// the rule engine and the protocol library.
abstract final class HealthAssessmentService {
  static HealthAssessment assess({
    required List<HealthCondition> conditions,
    required List<TreatmentProtocol> protocols,
    required Set<String> observedSymptoms,
    required HealthContext context,
    required HealthSeverity severity,
    required List<String> redFlagReasons,
    bool flockOutbreak = false,
  }) {
    final candidates = ConditionRuleEngine.evaluate(
      conditions: conditions,
      observedSymptoms: observedSymptoms,
      context: context,
    );

    final urgentFlags = redFlagReasons.toSet().toList();

    final anyUrgentVet = candidates.any(
      (c) =>
          c.condition.veterinaryReviewLevel == VeterinaryReviewLevel.urgent &&
          c.compatibility.rank >= CompatibilityLevel.possible.rank,
    );
    final riskLevel = urgentFlags.isNotEmpty || anyUrgentVet
        ? HealthRiskLevel.urgent
        : severity == HealthSeverity.mild && candidates.isEmpty
        ? HealthRiskLevel.routine
        : HealthRiskLevel.needsAttention;

    final actions = <String>[];
    for (final candidate in candidates.take(3)) {
      for (final action in candidate.condition.immediateActions) {
        if (!actions.contains(action)) actions.add(action);
      }
    }
    if (urgentFlags.isNotEmpty && !actions.contains('contact_vet')) {
      actions.add('contact_vet');
    }

    final pathways = <TreatmentPathway>[];
    final seenProtocols = <String>{};
    for (final candidate in candidates.take(4)) {
      for (final protocolId in candidate.condition.treatmentProtocolIds) {
        if (!seenProtocols.add(protocolId)) continue;
        final protocol = _protocolById(protocols, protocolId);
        if (protocol != null) {
          pathways.add(
            TreatmentPathway(
              conditionId: candidate.condition.id,
              protocol: protocol,
            ),
          );
        }
      }
    }

    final antibioticNotAutomaticallyIndicated = !pathways.any(
      (p) => p.protocol.treatmentType == TreatmentType.antimicrobial,
    );

    return HealthAssessment(
      riskLevel: riskLevel,
      candidates: candidates,
      urgentFlags: urgentFlags,
      immediateActions: actions,
      pathways: pathways,
      flockOutbreak: flockOutbreak,
      antibioticNotAutomaticallyIndicated: antibioticNotAutomaticallyIndicated,
    );
  }

  static TreatmentProtocol? _protocolById(
    List<TreatmentProtocol> protocols,
    String id,
  ) {
    for (final protocol in protocols) {
      if (protocol.id == id) return protocol;
    }
    return null;
  }
}
