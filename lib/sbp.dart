import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sbp/models/application_info_model.dart';
import 'package:sbp/models/asset_link_model.dart';
import 'package:sbp/models/c2bmembers_model.dart';

/// Плагин Flutter, с помощью которого можно получить список банков, установленных на устройстве
/// пользователя, а также запустить ссылку для оплаты СБП вида https://qr.nspk.ru/.../
class Sbp {
  static const MethodChannel _channel = MethodChannel('sbp');

  /// Получение списка банков, установленных на устройстве пользователя: Android
  /// передаем модель json, который приходит с https://qr.nspk.ru/.well-known/assetlinks.json
  static Future<List<ApplicationInfoModel>> getAndroidInstalledByAssetLinksJsonBanks(
    List<Map<String, dynamic>> assetLinks,
  ) async {
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

  /// Получение списка банков, установленных на устройстве пользователя: Android
  /// Передаем список package_name
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

  /// Получение списка банков, установленных на устройстве пользователя: Android
  /// список List<C2bmemberModel> и в ответ получаем List<C2bmemberModel> установленных банков
  static Future<List<C2bmemberModel>> getAndroidInstalledByC2bmembersModelBank(
    List<C2bmemberModel> c2bmembersData,
  ) async {
    /// Парсим список установленных банков с ссылки https://qr.nspk.ru/proxyapp/c2bmembers.json
    final c2bmembersModel = c2bmembersData;

    final List<String> packageNamesApplications =
        c2bmembersModel.map((c2bmemberData) => c2bmemberData.packageName).toList();

    /// отдаем список поддерживаемых банков(SBP) из https://qr.nspk.ru/.well-known/assetlinks.json
    /// (application_package_names) и сравниваем с установленными возвращаем список установленных банков
    final installedBanks = (await _channel
            .invokeMethod('getInstalledBanks', {'application_package_names': packageNamesApplications}) as List)
        .map(
          (installedBank) => ApplicationInfoModel.fromJson(installedBank as Map<dynamic, dynamic>),
        )
        .toList();
    List<C2bmemberModel> newC2bmembersModel = [];
    for (var c2bmemberModel in c2bmembersModel) {
      for (var installedBank in installedBanks) {
        if (c2bmemberModel.packageName == installedBank.packageName) {
          newC2bmembersModel.add(c2bmemberModel);
        }
      }
    }
    return newC2bmembersModel;
  }

  /// Получение списка банков, установленных на устройстве пользователя: IOS
  /// передаем список schemes
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
    for (int schemaApplicationsIndex = 0;
        schemaApplicationsIndex < schemaApplications.length;
        schemaApplicationsIndex++) {
      for (int indexInstalledSchema = 0; indexInstalledSchema < installedSchemas.length; indexInstalledSchema++) {
        if (schemaApplications[schemaApplicationsIndex] == installedSchemas[indexInstalledSchema]) {
          installedSchemeBanks.add(schemaApplications[schemaApplicationsIndex]);
        }
      }
    }
    return installedSchemeBanks;
  }

  /// Получение списка банков, установленных на устройстве пользователя: IOS
  /// список List<C2bmemberModel> и в ответ получаем List<C2bmemberModel> установленных банков
  static Future<List<C2bmemberModel>> getIOSInstalledByC2bmemberModelBanks(
      List<C2bmemberModel> c2bmemberListModel) async {
    final List<C2bmemberModel> schemaApplications = c2bmemberListModel;

    /// получаем список schema установленных банков
    final List<String> installedSchemas = (await _channel.invokeMethod('getInstalledBanks', {
      'schema_applications': schemaApplications.map((c2bmemberModel) => c2bmemberModel.schema).toList(),
    }) as List)
        .map((installed) => installed as String)
        .toList();
    final List<C2bmemberModel> installedSchemeBanks = [];

    /// сравниваем список schema с c2bmembersModel, который пришел с ссылки https://qr.nspk.ru/proxyapp/c2bmembers.json
    for (int schemaApplicationsIndex = 0;
        schemaApplicationsIndex < schemaApplications.length;
        schemaApplicationsIndex++) {
      for (int indexInstalledSchema = 0; indexInstalledSchema < installedSchemas.length; indexInstalledSchema++) {
        if (schemaApplications[schemaApplicationsIndex].schema == installedSchemas[indexInstalledSchema]) {
          installedSchemeBanks.add(schemaApplications[schemaApplicationsIndex]);
        }
      }
    }
    return installedSchemeBanks;
  }

  /// Получение списка банков, установленных на устройстве пользователя: IOS/Android
  /// список List<C2bmemberModel> и в ответ получаем List<C2bmemberModel> установленных банков
  static Future<List<C2bmemberModel>> getInstalledByC2bmemberModelBanks(
    List<C2bmemberModel> c2bmemberListModel,
  ) async {
    if (Platform.isIOS) {
      return await getIOSInstalledByC2bmemberModelBanks(c2bmemberListModel);
    }
    return await getAndroidInstalledByC2bmembersModelBank(
      c2bmemberListModel,
    );
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

  /// открываем банк: Android/IOS
  /// отдаем ссылку в виде 'https://qr.nspk.ru/...'
  /// schemaOrPackageName: com.example.android или bank10000000000
  static Future<bool> openBank(String url, String schemaOrPackageName) async {
    if (Platform.isIOS) {
      return await openBankIOS(url, schemaOrPackageName);
    }
    return await openAndroidBank(url, schemaOrPackageName);
  }
}
