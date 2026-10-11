import 'package:flutter/material.dart';

import '../../app/theme/app_theme_extension.dart';
import '../../features/sheep/domain/sheep_record.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, required this.label, super.key});

  final SheepHealthStatus status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppStatusColors>()!;
    final color = switch (status) {
      SheepHealthStatus.healthy => palette.healthy,
      SheepHealthStatus.attention => palette.attention,
      SheepHealthStatus.urgent => palette.urgent,
      SheepHealthStatus.withdrawal => palette.withdrawal,
    };
    return Container(
      constraints: const BoxConstraints(minHeight: 32),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        border: Border.all(color: color.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Semantics(
        label: label,
        child: ExcludeSemantics(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
