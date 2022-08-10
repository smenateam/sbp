import 'dart:typed_data';

class ApplicationInfoModel {
  late final String name;
  late final String packageName;
  late final Uint8List? bitmap;

  ApplicationInfoModel.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    packageName = json['package_name'];
    bitmap = json['bitmap'];
  }

  Map<String, dynamic> toMapPackageName() => {
    'package_name': packageName,
  };
}