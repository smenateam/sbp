import 'package:sbp/models/asset_link_target_model.dart';

/// данные, которые приходят с сервера: поддерживаемые банки(СБП) Android
class AssetLinkModel{
  List<String> relations = [];
  late AssetLinkTargetModel assetLinkTargetModel;

  AssetLinkModel.fromJson(Map<String,dynamic> json){
    relations.addAll((json['relation'] as List).map((relation) => relation));
    assetLinkTargetModel = AssetLinkTargetModel.fromJson(json['target']);
  }
}