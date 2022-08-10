import 'dart:async';
import 'dart:typed_data';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:sbp/assetLinks.dart';

class Sbp {
  static const MethodChannel _channel = MethodChannel('sbp');

  static Future<List<ApplicationInfo>> get getInstalledBanks async {
    final listApplicationInfo = assetLinks
        .map((target) => ApplicationInfo.fromJson(target['target'] as Map<String, dynamic>).toJson())
        .toList();
    final installedBanks =
        await _channel.invokeMethod('getInstalledBanks', {'listApplicationInfo': listApplicationInfo}) as List;
    final a = installedBanks.map((e) => ApplicationInfo.fromJson(e as Map<dynamic, dynamic>)).toList();
    return a;
  }

  static Future<bool> openBank(ApplicationInfo info) async {
    //launch('intent://qr.nspk.ru/AD10006K1GQ7788G9ACAAM970SGCOLNM?type=02&&sum=1100&cur=RUB&crc=CD70#Intent;scheme=bank100000000111;end');
    await _channel.invokeMethod('openBank', {
      'url': 'https://qr.nspk.ru/AD10006K1GQ7788G9ACAAM970SGCOLNM?type=02&&sum=1100&cur=RUB&crc=CD70',
      'applicationInfo': info.toJson()
    });
    return true;
  }
}

class ApplicationInfo {
  late final String packageName;
  late final String name;
  late final Uint8List bitmap;

  ApplicationInfo.fromJson(Map<dynamic, dynamic> json) {
    packageName = json['package_name'];
    name = json['namespace'] ?? json['name'];
    if(json['bitmap']!=null) {
      bitmap = json['bitmap'];
    }
    print(json['bitmap'].runtimeType);
    print(json['bitmap']);
  }

  Map<String, dynamic> toJson() => {'package_name': packageName, 'name': name};
}

class Bitmap {
  late final int alpha;
  late final int red;
  late final int green;
  late final int blue;

  Bitmap.fromJson(Map<dynamic, dynamic> json) {
    alpha = json['json'] ?? 0;
    red = json['red'];
    green = json['green'];
    blue = json['blue'];
  }
}
