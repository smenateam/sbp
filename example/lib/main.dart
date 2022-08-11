import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  List<C2bmemberModel> platformVersion = [];

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await Sbp.getIOSInstalledBanks(
          'bank100000000007', 'https://qr.nspk.ru/AD10006K1GQ7788G9ACAAM970SGCOLNM?type=02&&sum=1100&cur=RUB&crc=CD70');
    } on PlatformException {
      platformVersion = [];
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion.toString();
    });
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
              children: platformVersion
                  .map(
                    (e) => Column(
                      children: [
                        //Image.network(e.logoURL),
                        GestureDetector(
                          onTap: () => open(e.schema),
                          child: SizedBox(
                            height: 200,
                            child: Center(
                              child: Text('Running on: ${e.packageName}\n'),
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

  Future<void> open(String packageName) async {
    await Sbp.openIOS(packageName);
  }
}
