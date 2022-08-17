/// данные, которые приходят с сервера: поддерживаемые банки(СБП) IOS
class C2bmembersModel {
  /// [version] - версия json
  late final String version;

  /// [c2bmembersModel] - Список C2bmemberModel, которая содержит необходимую информацию о приложении
  List<C2bmemberModel> c2bmembersModel = [];

  /// Получение данных из словаря
  C2bmembersModel.fromJson(Map<String, dynamic> json) {
    version = json['version'] ?? '';
    c2bmembersModel.addAll((json['dictionary'] as List)
        .map((c2bmemberModel) => C2bmemberModel.fromJson(c2bmemberModel))
        .toList());
  }
}

/// Содержит всю необходимую информацию о приложении(IOS)
class C2bmemberModel {
  /// [bankName] - название приложения
  late final String bankName;

  /// [logoURL] - иконка приложения
  late final String logoURL;

  /// [schema] - schema приложения
  late final String schema;

  /// [packageName] - packageName приложения
  late final String packageName;

  /// Получение данных из словаря
  C2bmemberModel.fromJson(Map<String, dynamic> json) {
    bankName = json['bankName'] ?? '';
    logoURL = json['logoURL'] ?? '';
    schema = json['schema'] ?? '';
    packageName = json['package_name'] ?? '';
  }
}
