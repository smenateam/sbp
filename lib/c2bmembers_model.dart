class C2bmembersModel {
  late final String version;
  List<C2bmemberModel> c2bmembersModel = [];

  C2bmembersModel.fromJson(Map<String, dynamic> json) {
    version = json['version'] ?? '';
    c2bmembersModel
        .addAll((json['dictionary'] as List).map((c2bmemberModel) => C2bmemberModel.fromJson(c2bmemberModel)).toList());
  }
}

class C2bmemberModel {
  late final String name;
  late final String logoURL;
  late final String schema;
  late final String packageName;

  C2bmemberModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    logoURL = json['logoURL'] ?? '';
    schema = json['schema'] ?? '';
    packageName = json['package_name'] ?? '';
  }
}
