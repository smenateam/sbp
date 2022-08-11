import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sbp/application_info_model.dart';
import 'package:sbp/c2bmembers_model.dart';
import 'package:sbp/sbp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  List<ApplicationInfoModel> applicationInfoModel = [];
  List<C2bmemberModel> c2bmemberModel = [];

  Future<void> initPlatformState() async {
    try {
      if (Platform.isAndroid) {
        applicationInfoModel = await Sbp.getAndroidInstalledBanks;
      }
      if (Platform.isIOS) {
        c2bmemberModel = await Sbp.getIOSInstalledBanks;
      }
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
              children: applicationInfoModel
                  .map(
                    (applicationInfo) => Column(
                      children: [
                        //Image.network(e.logoURL),
                        GestureDetector(
                          onTap: () => openBank(applicationInfo.packageName),
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
                  .toList()),
        ),
      ),
    );
  }

  Future<void> openBank(String information) async {
    if (Platform.isAndroid) {
      await Sbp.openAndroidBank(information);
    }
    if (Platform.isIOS) {
      await Sbp.openBankIOS(information);
    }
  }
}
