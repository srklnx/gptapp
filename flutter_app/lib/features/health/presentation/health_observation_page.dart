import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/route_paths.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../core/widgets/app_section_title.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../groups/data/group_providers.dart';
import '../../quick_log/data/care_providers.dart';
import '../../sheep/data/sheep_providers.dart';
import '../data/condition_library.dart';
import '../data/health_providers.dart';
import '../domain/condition.dart';
import '../domain/flock_outbreak_service.dart';
import '../domain/health_assessment.dart';
import '../domain/health_observation.dart';
import '../domain/health_questionnaire.dart';
import '../domain/health_risk.dart';
import 'health_labels.dart';

/// Guided health observation flow: Observe → Record → Understand → Act.
class HealthObservationPage extends ConsumerStatefulWidget {
  const HealthObservationPage({this.initialSheepId, super.key});

  final String? initialSheepId;

  @override
  ConsumerState<HealthObservationPage> createState() =>
      _HealthObservationPageState();
}

class _HealthObservationPageState extends ConsumerState<HealthObservationPage> {
  int _step = 0;
  HealthTargetScope _scope = HealthTargetScope.individual;
  String? _sheepId;
  final Set<String> _symptoms = {};
  final Map<String, List<String>> _answers = {};
  HealthSeverity _severity = HealthSeverity.moderate;
  String? _savedObservationId;

  @override
  void initState() {
    super.initState();
    _sheepId = widget.initialSheepId;
    _scope = widget.initialSheepId != null
        ? HealthTargetScope.individual
        : HealthTargetScope.individual;
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(value: (_step + 1) / 5),
            Expanded(
              child: switch (_step) {
                0 => _whoStep(context, strings),
                1 => _symptomsStep(context, strings),
                2 => _questionsStep(context, strings),
                3 => _severityStep(context, strings),
                _ => _summaryStep(context, strings),
              },
            ),
            _bottomBar(context, strings),
          ],
        ),
      ),
    );
  }

  Widget _whoStep(BuildContext context, AppLocalizations strings) {
    final sheep = ref.watch(sheepRecordsProvider);
    final groups = ref.watch(flockGroupsProvider);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(strings.whoIsThisFor, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        RadioGroup<HealthTargetScope>(
          groupValue: _scope,
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _scope = value;
              if (value == HealthTargetScope.individual && _sheepId == null) {
                _sheepId = sheep.first.id;
              }
            });
          },
          child: Column(
            children: [
              RadioListTile<HealthTargetScope>(
                value: HealthTargetScope.individual,
                title: Text(strings.thisSheep),
              ),
              RadioListTile<HealthTargetScope>(
                value: HealthTargetScope.group,
                title: Text(strings.groupScope),
              ),
              RadioListTile<HealthTargetScope>(
                value: HealthTargetScope.flock,
                title: Text(strings.entireFlock),
              ),
            ],
          ),
        ),
        if (_scope == HealthTargetScope.individual)
          DropdownButtonFormField<String>(
            key: const Key('health-sheep-selector'),
            initialValue: _sheepId ?? sheep.first.id,
            decoration: InputDecoration(
              labelText: strings.selectSheep,
              border: const OutlineInputBorder(),
            ),
            items: [
              for (final animal in sheep)
                DropdownMenuItem(
                  value: animal.id,
                  child: Text(
                    '#${LocaleFormatters.textForContext(context, animal.tagNumber)} · ${animal.breed}',
                  ),
                ),
            ],
            onChanged: (value) => setState(() => _sheepId = value),
          ),
        if (_scope == HealthTargetScope.group)
          DropdownButtonFormField<String>(
            key: const Key('health-group-selector'),
            initialValue: groups.isEmpty ? null : groups.first.id,
            decoration: InputDecoration(
              labelText: strings.group,
              border: const OutlineInputBorder(),
            ),
            items: [
              for (final group in groups)
                DropdownMenuItem(
                  value: group.id,
                  child: Text('${group.name} · ${group.sheepCount}'),
                ),
            ],
            onChanged: (value) => setState(() => _selectedGroupId = value),
          ),
      ],
    );
  }

  String? _selectedGroupId;

  Widget _symptomsStep(BuildContext context, AppLocalizations strings) {
    final categories = SymptomCategory.values;
    return ListView(
      key: const Key('health-symptoms-step'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(strings.whatDidYouObserve, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        Text(strings.selectSymptoms),
        const SizedBox(height: AppSpacing.md),
        for (final category in categories) ...[
          Text(
            HealthLabels.category(strings, category),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final symptom in HealthSymptomCatalog.forCategory(category))
                FilterChip(
                  key: Key('symptom-${symptom.id}'),
                  label: Text(HealthLabels.symptom(strings, symptom.id)),
                  selected: _symptoms.contains(symptom.id),
                  onSelected: (selected) => setState(() {
                    selected
                        ? _symptoms.add(symptom.id)
                        : _symptoms.remove(symptom.id);
                  }),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }

  Widget _questionsStep(BuildContext context, AppLocalizations strings) {
    final questions = HealthQuestionnaireService.questionsFor(_symptoms);
    return ListView(
      key: const Key('health-questions-step'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(strings.followUpQuestions, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        for (final question in questions) ...[
          Text(
            HealthLabels.question(strings, question.id),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final option in question.options)
                ChoiceChip(
                  key: Key('answer-${question.id}-${option.id}'),
                  label: Text(HealthLabels.option(strings, option.id)),
                  selected: _answers[question.id]?.contains(option.id) ?? false,
                  onSelected: (selected) => setState(() {
                    final current = _answers[question.id] ?? <String>[];
                    if (selected) {
                      if (question.multiSelect) {
                        current.add(option.id);
                      } else {
                        current
                          ..clear()
                          ..add(option.id);
                      }
                    } else {
                      current.remove(option.id);
                    }
                    _answers[question.id] = current;
                  }),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }

  Widget _severityStep(BuildContext context, AppLocalizations strings) {
    final risk = HealthRiskService.assess(
      symptomIds: _symptoms,
      answers: _answers,
      severity: _severity,
    );
    return ListView(
      key: const Key('health-severity-step'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(strings.severity, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        SegmentedButton<HealthSeverity>(
          segments: [
            ButtonSegment(value: HealthSeverity.mild, label: Text(strings.severityMild)),
            ButtonSegment(
              value: HealthSeverity.moderate,
              label: Text(strings.severityModerate),
            ),
            ButtonSegment(value: HealthSeverity.severe, label: Text(strings.severitySevere)),
          ],
          selected: {_severity},
          onSelectionChanged: (value) => setState(() => _severity = value.first),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (risk.isUrgent) _UrgentWarning(reasons: risk.reasons, strings: strings),
      ],
    );
  }

  Widget _summaryStep(BuildContext context, AppLocalizations strings) {
    final risk = HealthRiskService.assess(
      symptomIds: _symptoms,
      answers: _answers,
      severity: _severity,
    );
    final assessment = _buildAssessment(risk);
    return ListView(
      key: const Key('health-summary-step'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(strings.healthAssessment, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        _RiskBadge(level: assessment.riskLevel, strings: strings),
        const SizedBox(height: AppSpacing.md),
        if (risk.isUrgent) ...[
          _UrgentWarning(reasons: risk.reasons, strings: strings),
          const SizedBox(height: AppSpacing.md),
        ],
        if (assessment.flockOutbreak) ...[
          _FlockWarning(strings: strings),
          const SizedBox(height: AppSpacing.md),
        ],
        Text(strings.observedSigns, style: Theme.of(context).textTheme.titleMedium),
        Text(
          _symptoms.map((id) => HealthLabels.symptom(strings, id)).join(' + '),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '${strings.severity}: ${HealthLabels.severity(strings, _severity)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (assessment.candidates.isNotEmpty) ...[
          AppSectionTitle(strings.conditionsToConsider),
          for (final candidate in assessment.candidates.take(3))
            _ConditionTile(candidate: candidate, strings: strings),
        ],
        if (assessment.pathways.isNotEmpty) ...[
          AppSectionTitle(strings.treatmentApproach),
          for (final pathway in assessment.pathways)
            _PathwayTile(pathway: pathway, strings: strings),
        ],
        if (assessment.antibioticNotAutomaticallyIndicated) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            strings.antibioticNotIndicated,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        if (assessment.immediateActions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          AppSectionTitle(strings.recommendedNextAction),
          for (final action in assessment.immediateActions)
            _Bullet(text: HealthLabels.action(strings, action)),
        ],
      ],
    );
  }

  HealthAssessment _buildAssessment(HealthRiskResult risk) {
    final context = _buildContext();
    final observations = ref.read(healthProvider).observations;
    final flockOutbreak = FlockOutbreakService.isOutbreak(
      observations: observations,
      now: DateTime.now(),
    );
    return HealthAssessmentService.assess(
      conditions: ConditionLibrary.conditions,
      protocols: ConditionLibrary.protocols,
      observedSymptoms: _symptoms,
      context: context,
      severity: _severity,
      redFlagReasons: risk.reasons,
      flockOutbreak: flockOutbreak,
    );
  }

  HealthContext _buildContext() {
    final sheep = _scope == HealthTargetScope.individual && _sheepId != null
        ? ref.read(sheepByIdProvider(_sheepId!))
        : null;
    final riskFactors = _answers['risk_factors'] ?? const <String>[];
    return HealthContext(
      ageGroup: sheep == null ? null : AgeGroup.fromBirthDate(sheep.birthDate),
      pregnant: sheep?.pregnant ?? false,
      lowBcs: (sheep?.bcs ?? 100) <= 2.0,
      riskFactorKeys: riskFactors.toSet(),
    );
  }

  Widget _bottomBar(BuildContext context, AppLocalizations strings) {
    final onLast = _step == 4;
    final canNext = switch (_step) {
      0 => _canResolveSheepIds(),
      1 => _symptoms.isNotEmpty,
      _ => true,
    };
    if (!onLast) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            if (_step > 0)
              OutlinedButton(
                key: const Key('health-back'),
                onPressed: () => setState(() => _step--),
                child: Text(strings.back),
              ),
            const Spacer(),
            FilledButton(
              key: const Key('health-next'),
              onPressed: canNext ? () => setState(() => _step++) : null,
              child: Text(strings.next),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              key: const Key('health-save-observation'),
              onPressed: _saveObservationAndPop,
              icon: const Icon(Icons.save_outlined),
              label: Text(strings.saveObservation),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  key: const Key('health-create-follow-up'),
                  onPressed: () => _createFollowUp(strings),
                  child: Text(strings.createFollowUp),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('health-record-treatment'),
                  onPressed: _recordTreatment,
                  icon: const Icon(Icons.medication_outlined),
                  label: Text(strings.recordTreatment),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _canResolveSheepIds() {
    return _scope != HealthTargetScope.individual || _sheepId != null;
  }

  List<String> _resolveSheepIds() {
    if (_scope == HealthTargetScope.individual) return [_sheepId!];
    if (_scope == HealthTargetScope.group) {
      final group = ref.read(flockGroupByIdProvider(_selectedGroupId!));
      return group?.sheepIds ?? [];
    }
    return ref.read(sheepRecordsProvider).map((animal) => animal.id).toList();
  }

  void _saveObservationAndPop() {
    final observation = _ensureSaved();
    if (observation != null && mounted) context.pop();
  }

  HealthObservation? _ensureSaved() {
    if (_savedObservationId == null) {
      final observation = ref.read(healthProvider.notifier).recordObservation(
        targetScope: _scope,
        sheepIds: _resolveSheepIds(),
        symptomIds: _symptoms,
        answers: _answers,
        severity: _severity,
        occurredAt: DateTime.now(),
        recordedBy: 'Ahmed',
      );
      _savedObservationId = observation.id;
      return observation;
    }
    return null;
  }

  void _recordTreatment() {
    _ensureSaved();
    final sheepId = _scope == HealthTargetScope.individual
        ? _sheepId
        : _resolveSheepIds().first;
    final query = [
      if (sheepId != null) 'sheepId=$sheepId',
      if (_savedObservationId != null) 'observationId=$_savedObservationId',
    ].join('&');
    context.push('$medicationLibraryRoute?$query');
  }

  Future<void> _createFollowUp(AppLocalizations strings) async {
    _ensureSaved();
    final titleController = TextEditingController(
      text: strings.treatmentFollowUp,
    );
    final dueDate = await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.createFollowUp),
        content: TextField(
          key: const Key('follow-up-title'),
          controller: titleController,
          decoration: InputDecoration(
            labelText: strings.followUpTitle,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(strings.cancel),
          ),
          FilledButton(
            key: const Key('confirm-follow-up'),
            onPressed: () => Navigator.pop(
              dialogContext,
              DateTime.now().add(const Duration(days: 1)),
            ),
            child: Text(strings.saveFollowUp),
          ),
        ],
      ),
    );
    if (dueDate == null || !mounted) return;
    ref.read(careProvider.notifier).createFollowUpTask(
      sheepIds: _resolveSheepIds(),
      title: titleController.text.trim().isEmpty
          ? strings.treatmentFollowUp
          : titleController.text.trim(),
      dueAt: dueDate,
      observationId: _savedObservationId,
    );
    if (mounted) context.pop();
  }
}

class _UrgentWarning extends StatelessWidget {
  const _UrgentWarning({required this.reasons, required this.strings});

  final List<String> reasons;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.error;
    return Container(
      key: const Key('urgent-attention'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.urgentAttention,
            style: TextStyle(color: color, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(strings.urgentAttentionBody),
          const SizedBox(height: AppSpacing.sm),
          for (final reason in reasons)
            Text('• ${HealthLabels.redFlag(strings, reason)}'),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.circle, size: 9),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

class _RiskBadge extends StatelessWidget {
  const _RiskBadge({required this.level, required this.strings});
  final HealthRiskLevel level;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    final color = switch (level) {
      HealthRiskLevel.routine => Theme.of(context).colorScheme.primary,
      HealthRiskLevel.needsAttention => const Color(0xFFA76510),
      HealthRiskLevel.urgent => Theme.of(context).colorScheme.error,
    };
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          border: Border.all(color: color.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          HealthLabels.riskLevel(strings, level),
          style: TextStyle(color: color, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _FlockWarning extends StatelessWidget {
  const _FlockWarning({required this.strings});
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.error;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.possibleFlockProblem,
            style: TextStyle(color: color, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(strings.flockProblemBody),
        ],
      ),
    );
  }
}

class _ConditionTile extends StatelessWidget {
  const _ConditionTile({required this.candidate, required this.strings});
  final ConditionCandidate candidate;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    final why = <String>[
      ...candidate.matchedRequired,
      ...candidate.matchedSupporting,
    ];
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ExpansionTile(
        title: Text(
          HealthLabels.condition(strings, candidate.condition.id),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          HealthLabels.compatibility(strings, candidate.compatibility),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.whyThisAppears, style: Theme.of(context).textTheme.titleSmall),
                for (final id in why.take(4))
                  _Bullet(text: HealthLabels.symptom(strings, id)),
                for (final factor in candidate.matchedRiskFactors)
                  _Bullet(text: HealthLabels.riskFactor(strings, factor)),
                const SizedBox(height: AppSpacing.sm),
                Text(strings.checkNext, style: Theme.of(context).textTheme.titleSmall),
                for (final check in candidate.condition.recommendedChecks.take(4))
                  _Bullet(text: HealthLabels.check(strings, check)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PathwayTile extends StatelessWidget {
  const _PathwayTile({required this.pathway, required this.strings});
  final TreatmentPathway pathway;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: ListTile(
      leading: const Icon(Icons.healing_outlined),
      title: Text(
        HealthLabels.protocolName(strings, pathway.protocol.name),
      ),
      subtitle: pathway.protocol.veterinaryRequired
          ? Text(strings.urgentVeterinaryAssessment)
          : pathway.protocol.veterinaryRecommended
          ? Text(strings.actionContactVet)
          : null,
    ),
  );
}
