import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

class AppSectionTitle extends StatelessWidget {
  const AppSectionTitle(this.title, {this.trailing, this.onTap, super.key});

  final String title;
  final String? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        if (trailing != null)
          TextButton(onPressed: onTap, child: Text(trailing!)),
      ],
    ),
  );
}
