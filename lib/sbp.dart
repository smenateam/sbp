import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sbp/models/c2bmembers_android_local_model.dart';
import 'package:sbp/models/c2bmembers_model.dart';

/// Плагин Flutter, с помощью которого можно получить список банков, установленных на устройстве
/// пользователя, а также запустить ссылку для оплаты СБП вида https://qr.nspk.ru/.../
class Sbp {
  static const MethodChannel _channel = MethodChannel('sbp');

  /// Получение списка банков, установленных на устройстве пользователя: IOS/Android
  /// передаем модель json, который приходит с https://qr.nspk.ru/proxyapp/c2bmembers.json (C2bmembersModel)
  static Future<List<C2bmemberModel>> getInstalledBanks(
      C2bmembersModel c2bmembersModel, {
    bool useAndroidLocalIcons = false,
    bool useAndroidLocalNames = false,
  }) async {

    final c2bmembersInstalled = <C2bmemberModel>[];
    if (Platform.isIOS) {
      /// Оставляем только schema для проверки присутствия на устройстве
      late final List<String> schemaApplications;
      schemaApplications = c2bmembersModel.c2bmembersModel.map((c2bmember) => c2bmember.schema).toList();

      /// получаем список schema установленных банков

      final List<String> installedApplications = (await _channel.invokeMethod('getInstalledBanks', {
        'schema_applications': schemaApplications,
      }) as List)
          .map((installed) => installed as String)
          .toList();

      /// сравниваем список schema с c2bmembersModel, который пришел с ссылки https://qr.nspk.ru/proxyapp/c2bmembers.json
      for (int c2bmembersModelIndex = 0;
          c2bmembersModelIndex < c2bmembersModel.c2bmembersModel.length;
          c2bmembersModelIndex++) {
        for (int indexInstalledSchema = 0;
            indexInstalledSchema < installedApplications.length;
            indexInstalledSchema++) {
          final schemaOrPackageName = c2bmembersModel.c2bmembersModel[c2bmembersModelIndex].schema;
          if (schemaOrPackageName == installedApplications[indexInstalledSchema]) {
            c2bmembersInstalled.add(c2bmembersModel.c2bmembersModel[c2bmembersModelIndex]);
          }
        }
      }
    } else {
      /// Оставляем только schema для проверки присутствия на устройстве
      late final List<String> packageNamesApplications =
          c2bmembersModel.c2bmembersModel.map((c2bmember) => c2bmember.packageName).toList();

      /// получаем список schema установленных банков
      final List<C2bmemberModelAndroidLocalData> installedApplications =
          (await _channel.invokeMethod('getInstalledBanks', {
        'application_package_names': packageNamesApplications,
        'use_android_local_icons': useAndroidLocalIcons,
        'use_android_local_names': useAndroidLocalNames,
      }) as List)
              .map((installed) => C2bmemberModelAndroidLocalData.fromJson(installed as Map<dynamic, dynamic>))
              .toList();

      /// сравниваем список schema с c2bmembersModel, который пришел с ссылки https://qr.nspk.ru/proxyapp/c2bmembers.json
      for (int c2bmembersModelIndex = 0;
          c2bmembersModelIndex < c2bmembersModel.c2bmembersModel.length;
          c2bmembersModelIndex++) {
        for (int indexInstalledSchema = 0;
            indexInstalledSchema < installedApplications.length;
            indexInstalledSchema++) {
          final packageName = c2bmembersModel.c2bmembersModel[c2bmembersModelIndex].packageName;
          if (packageName == installedApplications[indexInstalledSchema].packageName) {
            c2bmembersModel.c2bmembersModel[c2bmembersModelIndex].bitmap =
                installedApplications[indexInstalledSchema].bitmap;
            c2bmembersModel.c2bmembersModel[c2bmembersModelIndex].localName =
                installedApplications[indexInstalledSchema].localName;
            c2bmembersInstalled.add(c2bmembersModel.c2bmembersModel[c2bmembersModelIndex]);
          }
        }
      }
    }
    return c2bmembersInstalled;
  }

  /// открываем банк: Android
  /// отдаем ссылку в виде ('https://qr.nspk.ru/...' deprecated) bank10000000000://qr.nspk.ru/.
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
  /// c2bmemberModel установленный банк
  static Future<bool> openBank(String url, C2bmemberModel c2bmemberModel) async {
    if (Platform.isIOS) {
      return await openBankIOS(
        url,
        c2bmemberModel.schema,
      );
    }
    return await openAndroidBank(
      url.contains("https") ? url.replaceFirst("https", c2bmemberModel.schema) : url,
      c2bmemberModel.packageName,
    );
  }
}
