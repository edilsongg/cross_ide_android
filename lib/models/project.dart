import 'dart:io';

class Project {
  final String path;
  final String name;

  Project({required this.path})
      : name = path.split(Platform.pathSeparator).last;

  Map<String, dynamic> toJson() => {'path': path};
  static Project fromJson(Map<String, dynamic> json) =>
      Project(path: json['path']);
}
