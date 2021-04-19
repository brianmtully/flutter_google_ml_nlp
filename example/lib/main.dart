import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_google_ml_nlp/google_ml_nlp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  EntityExtractor entityExtractor = GoogleNLP.instance.entityExtractor();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await GoogleNLP.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(children: [
          Text('Running on: $_platformVersion\n'),
          TextButton(
              child: Text('Init'),
              onPressed: () async {
                await entityExtractor.init();
              }),
          TextButton(
              child: Text('Extract Entities from Text'),
              onPressed: () async {
                await entityExtractor.init();
                List result = await entityExtractor.annotate(
                    'Here is a longer string for my flight tomorrow 1Z8260540291249783');
                print("RESULT HERE");
                print(result);
              }),
        ]),
      ),
    );
  }
}
