import 'dart:convert';
import 'dart:io';

class LocalJsonStore {
  LocalJsonStore(Directory applicationSupportDirectory)
    : _directory = Directory(
        '${applicationSupportDirectory.path}${Platform.pathSeparator}herdhub-sheep',
      ) {
    _directory.createSync(recursive: true);
  }

  final Directory _directory;

  Map<String, Object?>? read(String fileName) {
    final file = File(_pathFor(fileName));
    if (!file.existsSync()) return null;
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is! Map) {
      throw FormatException('Stored ${file.path} is not a JSON object.');
    }
    return decoded.cast<String, Object?>();
  }

  void write(String fileName, Map<String, Object?> value) {
    File(_pathFor(fileName)).writeAsStringSync(jsonEncode(value), flush: true);
  }

  String _pathFor(String fileName) {
    if (fileName.contains('/') ||
        fileName.contains(r'\') ||
        fileName == '.' ||
        fileName == '..') {
      throw ArgumentError.value(fileName, 'fileName', 'Must be a file name.');
    }
    return '${_directory.path}${Platform.pathSeparator}$fileName';
  }
}
