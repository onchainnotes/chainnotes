import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String?> writeMnemonicBackupFile(String content) async {
  final dir = await getApplicationDocumentsDirectory();
  final name = 'mnemonic-backup-${DateTime.now().millisecondsSinceEpoch}.txt';
  final file = File('${dir.path}/$name');
  await file.writeAsString(content);
  return file.path;
}
