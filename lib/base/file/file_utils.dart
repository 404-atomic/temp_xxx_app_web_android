import 'dart:io';

File readFile(String path) {
  return File(path);
}

void writeFile(String path, String content) {
  File file = File(path);
  file.writeAsString(content);
}

/**
 * 遍历删除所有文件
 */
void deleteFile(String path) {
  File file = File(path);
  file.delete();
}

String randomFileName() {
  return DateTime.now().millisecondsSinceEpoch.toString();
}
