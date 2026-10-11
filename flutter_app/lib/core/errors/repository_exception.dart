class DuplicateSheepTagException implements Exception {
  const DuplicateSheepTagException(this.farmId, this.tagNumber);

  final String farmId;
  final String tagNumber;

  @override
  String toString() =>
      'Tag number "$tagNumber" already exists in farm "$farmId".';
}
