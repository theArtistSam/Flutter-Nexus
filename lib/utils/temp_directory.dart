import 'dart:io';
import 'package:open_file/open_file.dart';

class TempDirectory {
  static Future<void> emptyDirectory() async {
    final Directory tempDir = Directory.systemTemp;
    if (await tempDir.exists()) {
      final List<FileSystemEntity> tempFiles = tempDir.listSync();
      for (final FileSystemEntity file in tempFiles) {
        try {
          if (file is File) {
            await file.delete();
          } else if (file is Directory) {
            await file.delete(recursive: true);
          }
        } catch (e) {
          print('Failed to delete temporary file: $e');
        }
      }
      print('Temporary directory cleared.');
    }
  }
}
