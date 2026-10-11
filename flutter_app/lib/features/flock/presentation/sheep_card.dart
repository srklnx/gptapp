import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_radii.dart';
import '../../../app/route_paths.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../sheep/domain/sheep_record.dart';

class SheepCard extends StatelessWidget {
  const SheepCard({
    required this.sheep,
    this.status,
    this.withdrawalDays,
    super.key,
  });

  final SheepRecord sheep;
  final SheepHealthStatus? status;
  final int? withdrawalDays;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final displayedStatus = status ?? sheep.status;
    return Card(
      margin: const EdgeInsets.only(bottom: 9),
      color: Theme.of(context).cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: InkWell(
        key: Key('sheep-card-${sheep.id}'),
        excludeFromSemantics: false,
        onTap: () => context.push('$flockRoute/sheep/${sheep.id}'),
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _Avatar(sex: sheep.sex),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '#${LocaleFormatters.textForContext(context, sheep.tagNumber)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        StatusBadge(
                          status: displayedStatus,
                          label: _statusLabel(strings, displayedStatus),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${_breed(strings, sheep.breed)} · ${_sex(strings, sheep.sex)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 12,
                      children: [
                        _Fact(
                          label: strings.weight,
                          value:
                              '${LocaleFormatters.numberForContext(context, sheep.weightKg, decimalDigits: 1)} kg',
                        ),
                        _Fact(
                          label: strings.bcs,
                          value: LocaleFormatters.numberForContext(
                            context,
                            sheep.bcs,
                            decimalDigits: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      LocaleFormatters.textForContext(
                        context,
                        '${strings.nextRoutine}: ${withdrawalDays == null ? _routine(strings, sheep.nextRoutine) : strings.withdrawalDays(withdrawalDays!)}',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.chevron_left
                    : Icons.chevron_right,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _statusLabel(AppLocalizations s, SheepHealthStatus status) =>
      switch (status) {
        SheepHealthStatus.healthy => s.healthy,
        SheepHealthStatus.attention => s.attention,
        SheepHealthStatus.urgent => s.urgent,
        SheepHealthStatus.withdrawal => s.withdrawal,
      };

  static String _sex(AppLocalizations s, SheepSex sex) => switch (sex) {
    SheepSex.ewe => s.sexEwe,
    SheepSex.ram => s.sexRam,
    SheepSex.lamb => s.sexLamb,
  };

  static String _breed(AppLocalizations s, String breed) => switch (breed) {
    'Awassi' => s.breedAwassi,
    'Najdi' => s.breedNajdi,
    'Naimi' => s.breedNaimi,
    'Suffolk' => s.breedSuffolk,
    _ => breed,
  };

  static String _routine(AppLocalizations s, String routine) {
    if (routine.startsWith('Vaccination')) {
      return '${s.routineVaccination} · ${s.routineDueInDays}';
    }
    if (routine.startsWith('Deworming')) {
      return '${s.routineDeworming} · ${s.dewormingInDays}';
    }
    if (routine.startsWith('Hoof trim')) {
      return '${s.routineHoof} · ${s.hoofTrimInWeeks}';
    }
    if (routine.startsWith('Weight check')) {
      return s.weightCheckDue;
    }
    if (routine.startsWith('Withdrawal')) {
      return s.withdrawalDueDays;
    }
    if (routine.startsWith('BCS')) {
      return s.bcsCheckDue;
    }
    return routine.contains('Healthy') ? s.routineNotDue : routine;
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.sex});

  final SheepSex sex;

  @override
  Widget build(BuildContext context) => Container(
    width: 48,
    height: 48,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      sex == SheepSex.ram ? '🐏' : '🐑',
      style: const TextStyle(fontSize: 25),
    ),
  );
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      text: '$label ',
      style: Theme.of(context).textTheme.bodySmall
          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      children: [
        TextSpan(
          text: value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
