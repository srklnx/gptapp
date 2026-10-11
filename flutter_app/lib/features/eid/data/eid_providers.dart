import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/eid_readiness.dart';

final eidCriteriaProvider = Provider<EidCriteria>(
  (ref) => const EidCriteria(minimumWeightKg: 40, minimumBcs: 2.5),
);
