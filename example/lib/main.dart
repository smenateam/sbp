import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sbp/asset_links_data.dart';
import 'package:sbp/c2bmembers_data.dart';
import 'package:sbp/sbp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  final url =
      'https://qr.nspk.ru/AS10003P3RH0LJ2A9ROO038L6NT5RU1M?type=01&bank=000000000001&sum=10000&cur=RUB&crc=F3D0';

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getInstalledBanks();
  }

  List<dynamic> informations = [];

  Future<void> getInstalledBanks() async {
    try {
      if (Platform.isAndroid) {
        informations = await Sbp.getAndroidInstalledByAssetLinksJsonBanks(assetLinksData);
      }
      if (Platform.isIOS) {
        informations = await Sbp.getIOSInstalledByC2bmembersJsonBanks(c2bmembersData);
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('СПБ'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (Platform.isAndroid)
                ...informations
                    .map(
                      (applicationInfo) => Column(
                        children: [
                          Image.memory(applicationInfo.bitmap!),
                          GestureDetector(
                            onTap: () => openAndroidBank(widget.url, applicationInfo.packageName),
                            child: SizedBox(
                              height: 200,
                              child: Center(
                                child: Text('Running on: ${applicationInfo.name}\n'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              if (Platform.isIOS)
                ...informations
                    .map(
                      (c2bmember) => Column(
                        children: [
                          //Image.network(c2bmember.logoURL),
                          GestureDetector(
                            onTap: () => openIOSBank(widget.url, c2bmember.schema),
                            child: SizedBox(
                              height: 200,
                              child: Center(
                                child: Text('Running on: ${c2bmember.bankName}\n'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
            ],
          ),
        ),
      ),
    );
  }

  /// передается package_name
  Future<void> openAndroidBank(String url, String packageName) async => await Sbp.openAndroidBank(url, packageName);

  /// передается scheme
  Future<void> openIOSBank(String url, String scheme) async => await Sbp.openBankIOS(url, scheme);
}
