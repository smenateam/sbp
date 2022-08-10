import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sbp/assetLinks.dart';

class Sbp {
  static const MethodChannel _channel = MethodChannel('sbp');

  static Future<String?> get getInstalledBanks async {
    final listApplicationInfo = assetLinks.map((target) =>
        ApplicationInfo.fromJson(target['target'] as Map<String, dynamic>).toJson()).toList();
    final String? version = await _channel.invokeMethod(
        'getInstalledBanks', {'listApplicationInfo': listApplicationInfo});
    return version;
  }
}

class ApplicationInfo {
  late final String packageName;
  late final String name;

  ApplicationInfo.fromJson(Map<String, dynamic> json){
    packageName = json['package_name'];
    name = json['namespace'];
  }

  Map<String, dynamic> toJson() => {'package_name': packageName, 'name': name};
}