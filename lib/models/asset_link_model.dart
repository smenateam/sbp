import 'package:sbp/models/asset_link_target_model.dart';

/// данные, которые приходят с сервера: поддерживаемые банки(СБП) Android
class AssetLinkModel {
  /// [relations] - Список пермишенов
  List<String> relations = [];

  /// [assetLinkTargetModel] - модель, которая содердит в себе всю необходимую ифнормацию приложения
  late AssetLinkTargetModel assetLinkTargetModel;

  /// Получение данных из словаря
  AssetLinkModel.fromJson(Map<String, dynamic> json) {
    relations.addAll((json['relation'] as List).map((relation) => relation));
    assetLinkTargetModel = AssetLinkTargetModel.fromJson(json['target']);
  }
}
