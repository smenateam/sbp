import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  List<ApplicationInfo> platformVersion = [];

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await Sbp.getInstalledBanks;
      print(platformVersion);
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
        body: Column(
            children: platformVersion
                .map(
                  (e) => Column(
                    children: [
                      Image.memory(e.bitmap),
                      GestureDetector(
                        onTap: () => openBank(e),
                        child: SizedBox(
                          height: 200,
                          child: Center(
                            child: Text('Running on: $_platformVersion\n'),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList()),
      ),
    );
  }

  Future<void> openBank(ApplicationInfo info) async {
    await Sbp.openBank(info);
  }
}
