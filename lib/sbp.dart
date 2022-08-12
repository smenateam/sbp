import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sbp/models/application_info_model.dart';
import 'package:sbp/models/asset_link_model.dart';
import 'package:sbp/models/c2bmembers_model.dart';

class Sbp {
  static const MethodChannel _channel = MethodChannel('sbp');

  /// Получение списка банков, установленных на устройстве пользователя: Android
  /// передаем модель json, который приходит с https://qr.nspk.ru/.well-known/assetlinks.json
  static Future<List<ApplicationInfoModel>> getAndroidInstalledByAssetLinksJsonBanks(
      List<Map<String, dynamic>> assetLinks) async {
    final List<String> packageNamesApplications =
        assetLinks.map((assetLink) => AssetLinkModel.fromJson(assetLink).assetLinkTargetModel.packageName).toList();

    /// отдаем список поддерживаемых банков(SBP) из https://qr.nspk.ru/.well-known/assetlinks.json
    /// (application_package_names) и сравниваем с установленными возвращаем список установленных банков
    final installedBanks = (await _channel
            .invokeMethod('getInstalledBanks', {'application_package_names': packageNamesApplications}) as List)
        .map(
          (installedBank) => ApplicationInfoModel.fromJson(installedBank as Map<dynamic, dynamic>),
        )
        .toList();
    return installedBanks;
  }

  static Future<List<String>> getAndroidInstalledByPackageNameBanks(List<String> packageNames) async {
    final List<String> packageNameApplications = packageNames;

    /// отдаем список поддерживаемых банков(SBP) из https://qr.nspk.ru/.well-known/assetlinks.json
    /// (application_package_names) и сравниваем с установленными возвращаем список установленных банков
    final List<String> installedPackageNameBanks = (await _channel
            .invokeMethod('getInstalledBanks', {'application_package_names': packageNameApplications}) as List)
        .map(
          (installedBank) => installedBank as String,
        )
        .toList();
    return installedPackageNameBanks;
  }

  /// Получение списка банков, установленных на устройстве пользователя: IOS
  /// передаем модель json, который приходит с https://qr.nspk.ru/proxyapp/c2bmembers.json
  static Future<List<C2bmemberModel>> getIOSInstalledByC2bmembersJsonBanks(Map<String, dynamic> c2bmembersData) async {
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

  static Future<List<String>> getIOSInstalledBySchemesBanks(List<String> schemes) async {
    final List<String> schemaApplications = schemes;

    /// получаем список schema установленных банков
    final List<String> installedSchemas = (await _channel.invokeMethod('getInstalledBanks', {
      'schema_applications': schemaApplications,
    }) as List)
        .map((installed) => installed as String)
        .toList();
    final List<String> installedSchemeBanks = [];

    /// сравниваем список schema с c2bmembersModel, который пришел с ссылки https://qr.nspk.ru/proxyapp/c2bmembers.json
    for (int schemaApplicationsIndex = 0; schemaApplicationsIndex < schemaApplications.length; schemaApplicationsIndex++) {
      for (int indexInstalledSchema = 0; indexInstalledSchema < installedSchemas.length; indexInstalledSchema++) {
        if (schemaApplications[schemaApplicationsIndex] == installedSchemas[indexInstalledSchema]) {
          installedSchemeBanks.add(schemaApplications[schemaApplicationsIndex]);
        }
      }
    }
    return installedSchemeBanks;
  }

  /// открываем банк: Android
  /// отдаем ссылку в виде 'https://qr.nspk.ru/...'
  /// package_name: com.example.android
  static Future<bool> openAndroidBank(
    String url,
    String packageName,
  ) async =>
      await _channel.invokeMethod(
        'openBank',
        {
          'url': url,
          'package_name': packageName,
        },
      );

  /// открываем банк: IOS
  /// отдаем ссылку в виде 'https://qr.nspk.ru/...'
  /// schema: bank10000000000
  static Future<bool> openBankIOS(String url, String schema) async => await _channel.invokeMethod(
        'openBank',
        {
          'url': url,
          'schema': schema,
        },
      );
}
