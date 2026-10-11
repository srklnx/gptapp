import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/heat_stress.dart';

final heatStressThresholdsProvider = Provider<HeatStressThresholds>(
  (ref) => const HeatStressThresholds(),
);
