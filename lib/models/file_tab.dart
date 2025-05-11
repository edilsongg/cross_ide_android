import 'dart:io';

class FileTab {
  final String path;
  FileTab(this.path);

  String get name => path.split(Platform.pathSeparator).last;
}
