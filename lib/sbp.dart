import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sbp/application_info_model.dart';
import 'package:sbp/assetLinks.dart';
import 'package:sbp/asset_link_model.dart';

class Sbp {
  static const MethodChannel _channel = MethodChannel('sbp');

  static Future<List<ApplicationInfoModel>> get getInstalledBanks async {
    final List<String> packageNamesApplications =
        assetLinks.map((assetLink) => AssetLinkModel.fromJson(assetLink).assetLinkTargetModel.packageName).toList();
    final installedBanks = (await _channel
            .invokeMethod('getInstalledBanks', {'application_package_names': packageNamesApplications}) as List)
        .map(
          (installedBank) => ApplicationInfoModel.fromJson(installedBank as Map<dynamic, dynamic>),
        )
        .toList();
    return installedBanks;
  }

  static Future<bool> openBank(String packageName) async => await _channel.invokeMethod(
        'openBank',
        {
          'url': 'https://qr.nspk.ru/AD10006K1GQ7788G9ACAAM970SGCOLNM?type=02&&sum=1100&cur=RUB&crc=CD70',
          'package_name': packageName,
        },
      );
}
