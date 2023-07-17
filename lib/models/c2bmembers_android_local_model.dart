import 'dart:typed_data';

class C2bmemberModelAndroidLocalData {
  /// [localName] - локальное название банка, если выставить use_android_local_names = true
  late final String localName;

  /// [bitmap] - иконка приложения, если выставить use_android_local_icons = true
  late final Uint8List? bitmap;
  /// [packageName] - package_name приложения
  late final String? packageName;

  /// Получение данных из словаря
  C2bmemberModelAndroidLocalData.fromJson(Map<dynamic, dynamic> json) {
    localName = json['name'] ?? '';
    bitmap = json['bitmap'];
    packageName = json['package_name'] ?? '';
  }
}
