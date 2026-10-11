import 'sheep_record.dart';

abstract interface class SheepDirectoryRepository {
  List<SheepRecord> getAll();
  SheepRecord? getById(String id);
  void add(SheepRecord sheep);
  void update(SheepRecord sheep);
  SheepRecord? findByTagNumber(String tagNumber);
}
