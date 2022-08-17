import 'dart:typed_data';

/// данные, которые приходят из натива Android
class ApplicationInfoModel {
  /// [name] - имя приложения
  late final String name;

  /// [packageName] - packageName приложения
  late final String packageName;

  /// [packageName] - иконка приложения
  late final Uint8List? bitmap;

  /// Получение данных из словаря
  ApplicationInfoModel.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'] ?? '';
    packageName = json['package_name'] ?? '';
    bitmap = json['bitmap'];
  }

  /// Получение package_name в виде словаря
  Map<String, dynamic> toMapPackageName() => {
        'package_name': packageName,
      };
}
