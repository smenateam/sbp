import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sbp/application_info_model.dart';
import 'package:sbp/assetLinks.dart';
import 'package:sbp/asset_link_model.dart';
import 'package:sbp/c2bmembers_model.dart';

import 'c2bmembers_data.dart';

class Sbp {
  static const MethodChannel _channel = MethodChannel('sbp');

  /// Получение списка банков, установленных на устройстве пользователя: Android
  static Future<List<ApplicationInfoModel>> get getAndroidInstalledBanks async {
    final List<String> packageNamesApplications =
        assetLinks.map((assetLink) => AssetLinkModel.fromJson(assetLink).assetLinkTargetModel.packageName).toList();
    /// отдаем список поддерживаемых банков(SBP) из https://qr.nspk.ru/.well-known/assetlinks.json (application_package_names) и сравниваем с установленными
    /// возвращаем список установленных банков
    final installedBanks = (await _channel
            .invokeMethod('getInstalledBanks', {'application_package_names': packageNamesApplications}) as List)
        .map(
          (installedBank) => ApplicationInfoModel.fromJson(installedBank as Map<dynamic, dynamic>),
        )
        .toList();
    return installedBanks;
  }

  /// Получение списка банков, установленных на устройстве пользователя: IOS
  static Future<List<C2bmemberModel>> get getIOSInstalledBanks async {
    /// Парсим список установленных банков с ссылки https://qr.nspk.ru/proxyapp/c2bmembers.json
    final c2bmembersModel = C2bmembersModel.fromJson(c2bmembersData);
    /// Оставляем только schema для проверки присутствия на устройстве
    final List<String> schemaApplications =
        c2bmembersModel.c2bmembersModel.map((c2bmember) => c2bmember.schema).toList();
    /// получаем список schema установленных банков
    final List<String> installedSchemas = (await _channel.invokeMethod('getInstalledBanks', {
      'schema_applications': schemaApplications,
    }) as List)
        .map((installed) => installed as String)
        .toList();
    final c2bmembersInstalled = <C2bmemberModel>[];
    /// сравниваем список schema с c2bmembersModel, который пришел с ссылки https://qr.nspk.ru/proxyapp/c2bmembers.json
    for (int c2bmembersModelIndex = 0;
        c2bmembersModelIndex < c2bmembersModel.c2bmembersModel.length;
        c2bmembersModelIndex++) {
      for (int indexInstalledSchema = 0; indexInstalledSchema < installedSchemas.length; indexInstalledSchema++) {
        if (c2bmembersModel.c2bmembersModel[c2bmembersModelIndex].schema == installedSchemas[indexInstalledSchema]) {
          c2bmembersInstalled.add(c2bmembersModel.c2bmembersModel[c2bmembersModelIndex]);
        }
      }
    }
    return c2bmembersInstalled;
  }

  /// открываем банк: Android
  /// отдаем ссылку в виде 'https://qr.nspk.ru/...'
  static Future<bool> openAndroidBank(String packageName) async => await _channel.invokeMethod(
        'openBank',
        {
          'url': 'https://qr.nspk.ru/AD10006K1GQ7788G9ACAAM970SGCOLNM?type=02&&sum=1100&cur=RUB&crc=CD70',
          'package_name': packageName,
        },
      );

  /// открываем банк: IOS
  /// отдаем ссылку в виде 'https://qr.nspk.ru/...'
  static Future<bool> openBankIOS(String schema) async => await _channel.invokeMethod(
        'openBank',
        {
          'url': 'https://qr.nspk.ru/AD10006K1GQ7788G9ACAAM970SGCOLNM?type=02&&sum=1100&cur=RUB&crc=CD70',
          'schema': schema,
        },
      );
}
