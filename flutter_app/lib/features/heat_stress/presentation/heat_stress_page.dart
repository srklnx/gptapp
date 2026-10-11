import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_theme_extension.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../features/quick_log/data/care_providers.dart';
import '../../../features/quick_log/domain/care_records.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/heat_stress_providers.dart';
import '../domain/heat_stress.dart';

class HeatStressPage extends ConsumerWidget {
  const HeatStressPage({this.initialSheepId, super.key});

  final String? initialSheepId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final care = ref.watch(careProvider);
    final thresholds = ref.watch(heatStressThresholdsProvider);
    const temperature = 43.0;
    const humidity = 28.0;
    final assessment = HeatStressService.assess(
      temperatureC: temperature,
      relativeHumidity: humidity,
      thresholds: thresholds,
    );
    final recentChecks = care.events.whereType<HeatCheckEvent>().toList()
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

    return ListView(
      key: const Key('heat-stress-page'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          strings.heatStressTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        _RiskPanel(
          level: assessment.level,
          thi: assessment.thi,
          temperature: temperature,
          humidity: humidity,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          strings.heatFactors,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        _Factor(
          icon: Icons.thermostat,
          label: strings.temperature,
          value:
              '${LocaleFormatters.numberForContext(context, temperature, decimalDigits: 0)}°C',
        ),
        _Factor(
          icon: Icons.water_drop_outlined,
          label: strings.humidity,
          value:
              '${LocaleFormatters.numberForContext(context, humidity, decimalDigits: 0)}%',
        ),
        _Factor(
          icon: Icons.calculate_outlined,
          label: strings.thiIndex,
          value: LocaleFormatters.numberForContext(
            context,
            assessment.thi,
            decimalDigits: 1,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          strings.recommended,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        _Recommendation(icon: Icons.park_outlined, text: strings.moveToShade),
        _Recommendation(
          icon: Icons.water_drop_outlined,
          text: strings.checkWater,
        ),
        _Recommendation(
          icon: Icons.front_hand_outlined,
          text: strings.avoidHandling,
        ),
        _Recommendation(icon: Icons.schedule, text: strings.recheckInThirty),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 56,
          child: FilledButton.icon(
            key: const Key('record-heat-check'),
            onPressed: () => _showHeatCheckDialog(
              context,
              ref,
              initialSheepId: initialSheepId,
              thresholds: thresholds,
            ),
            icon: const Icon(Icons.add_task),
            label: Text(strings.recordHeatCheck),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          strings.recentHeatChecks,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (recentChecks.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(strings.noHeatChecks),
          )
        else
          for (final check in recentChecks.take(5))
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(_riskIcon(_parseRisk(check.riskLevel))),
              title: Text(
                '${_riskName(strings, _parseRisk(check.riskLevel))} · ${LocaleFormatters.numberForContext(context, check.temperatureC, decimalDigits: 1)}°C',
              ),
              subtitle: Text(
                '${LocaleFormatters.dateForContext(context, check.occurredAt)} · ${LocaleFormatters.numberForContext(context, check.humidityPercent, decimalDigits: 0)}% · ${strings.thiIndex} ${LocaleFormatters.numberForContext(context, check.thi, decimalDigits: 1)}',
              ),
            ),
      ],
    );
  }

  static Future<void> _showHeatCheckDialog(
    BuildContext context,
    WidgetRef ref, {
    String? initialSheepId,
    required HeatStressThresholds thresholds,
  }) async {
    final strings = AppLocalizations.of(context);
    final temperatureController = TextEditingController(text: '43');
    final humidityController = TextEditingController(text: '28');
    final notesController = TextEditingController();
    final selectedSymptoms = <String>{};
    final actions = <String>{};
    var waterAvailable = true;
    var shadeAvailable = true;
    final result =
        await showDialog<
          (double, double, List<String>, bool, bool, List<String>, String)
        >(
          context: context,
          builder: (dialogContext) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: Text(strings.recordHeatCheck),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: temperatureController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: '${strings.temperature} °C',
                      ),
                    ),
                    TextField(
                      controller: humidityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '${strings.humidity} %',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(strings.symptoms),
                    for (final symptom in [
                      strings.panting,
                      strings.lethargy,
                      strings.excessiveSalivation,
                    ])
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(symptom),
                        value: selectedSymptoms.contains(symptom),
                        onChanged: (selected) => setState(() {
                          if (selected == true) {
                            selectedSymptoms.add(symptom);
                          } else {
                            selectedSymptoms.remove(symptom);
                          }
                        }),
                      ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(strings.waterAvailable),
                      value: waterAvailable,
                      onChanged: (value) =>
                          setState(() => waterAvailable = value),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(strings.shadeAvailable),
                      value: shadeAvailable,
                      onChanged: (value) =>
                          setState(() => shadeAvailable = value),
                    ),
                    Text(strings.actionsTaken),
                    for (final action in [
                      strings.moveToShade,
                      strings.checkWater,
                      strings.avoidHandling,
                    ])
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(action),
                        value: actions.contains(action),
                        onChanged: (selected) => setState(() {
                          if (selected == true) {
                            actions.add(action);
                          } else {
                            actions.remove(action);
                          }
                        }),
                      ),
                    TextField(
                      controller: notesController,
                      minLines: 1,
                      maxLines: 3,
                      decoration: InputDecoration(labelText: strings.notes),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    MaterialLocalizations.of(context).cancelButtonLabel,
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    final temperature = LocaleFormatters.parseNumber(
                      temperatureController.text,
                    )?.toDouble();
                    final humidity = LocaleFormatters.parseNumber(
                      humidityController.text,
                    )?.toDouble();
                    if (temperature == null ||
                        humidity == null ||
                        !temperature.isFinite ||
                        !humidity.isFinite ||
                        humidity < 0 ||
                        humidity > 100) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(strings.invalidValue)),
                      );
                      return;
                    }
                    Navigator.pop(dialogContext, (
                      temperature,
                      humidity,
                      selectedSymptoms.toList(),
                      waterAvailable,
                      shadeAvailable,
                      actions.toList(),
                      notesController.text.trim(),
                    ));
                  },
                  child: Text(strings.saveRecord),
                ),
              ],
            ),
          ),
        );
    temperatureController.dispose();
    humidityController.dispose();
    notesController.dispose();
    if (result == null || !context.mounted) return;
    ref
        .read(careProvider.notifier)
        .recordHeatCheck(
          sheepId: initialSheepId ?? 'flock',
          temperatureC: result.$1,
          humidityPercent: result.$2,
          symptoms: result.$3,
          waterAvailable: result.$4,
          shadeAvailable: result.$5,
          actionsTaken: result.$6,
          notes: result.$7,
          occurredAt: DateTime.now(),
          recordedBy: 'Ahmed',
          thresholds: thresholds,
        );
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(strings.savedLocallyWaiting)));
  }
}

class _RiskPanel extends StatelessWidget {
  const _RiskPanel({
    required this.level,
    required this.thi,
    required this.temperature,
    required this.humidity,
  });

  final HeatRiskLevel level;
  final double thi;
  final double temperature;
  final double humidity;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final color = _riskColor(context, level);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_riskIcon(level), color: color, size: 30),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  _riskName(strings, level),
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(color: color, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '${LocaleFormatters.numberForContext(context, temperature, decimalDigits: 0)}°C',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(
            '${LocaleFormatters.numberForContext(context, humidity, decimalDigits: 0)}% ${strings.humidity} · ${strings.thiIndex} ${LocaleFormatters.numberForContext(context, thi, decimalDigits: 1)}',
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(strings.heatRiskGuidance),
        ],
      ),
    );
  }
}

class _Factor extends StatelessWidget {
  const _Factor({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon),
    title: Text(label),
    trailing: Text(value, style: Theme.of(context).textTheme.titleMedium),
  );
}

class _Recommendation extends StatelessWidget {
  const _Recommendation({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
    title: Text(text),
  );
}

Color _riskColor(BuildContext context, HeatRiskLevel level) {
  final colors = Theme.of(context).extension<AppStatusColors>()!;
  return switch (level) {
    HeatRiskLevel.safe => colors.healthy,
    HeatRiskLevel.alert => colors.attention,
    HeatRiskLevel.danger => colors.urgent,
    HeatRiskLevel.emergency => colors.urgent,
  };
}

IconData _riskIcon(HeatRiskLevel level) => switch (level) {
  HeatRiskLevel.safe => Icons.check_circle_outline,
  HeatRiskLevel.alert => Icons.info_outline,
  HeatRiskLevel.danger => Icons.warning_amber_rounded,
  HeatRiskLevel.emergency => Icons.emergency,
};

String _riskName(AppLocalizations strings, HeatRiskLevel level) =>
    switch (level) {
      HeatRiskLevel.safe => strings.heatRiskSafe,
      HeatRiskLevel.alert => strings.heatRiskAlert,
      HeatRiskLevel.danger => strings.heatRiskDanger,
      HeatRiskLevel.emergency => strings.heatRiskEmergency,
    };

HeatRiskLevel _parseRisk(String value) =>
    HeatRiskLevel.values.firstWhere((level) => level.name == value);
