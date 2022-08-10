import 'package:sbp/asset_link_target_model.dart';

class AssetLinkModel{
  List<String> relations = [];
  late AssetLinkTargetModel assetLinkTargetModel;

  AssetLinkModel.fromJson(Map<String,dynamic> json){
    relations.addAll((json['relation'] as List).map((relation) => relation));
    assetLinkTargetModel = AssetLinkTargetModel.fromJson(json['target']);
  }
}