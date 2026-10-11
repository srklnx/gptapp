import 'package:flutter/foundation.dart';

@immutable
class DiagnosticTest {
  const DiagnosticTest({
    required this.id,
    required this.name,
    this.conditionIds = const [],
    this.sampleType = '',
    this.purpose = '',
    this.availability = '',
    this.notes = '',
  });

  final String id;
  final String name;
  final List<String> conditionIds;
  final String sampleType;
  final String purpose;
  final String availability;
  final String notes;
}
