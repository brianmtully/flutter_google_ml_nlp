import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_ml_nlp/google_ml_nlp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String submitText = '';
  List<EntityAnnotation> results;
  EntityExtractor entityExtractor = GoogleNLP.instance.entityExtractor();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Enter Text..'),
                    onChanged: (String newValue) {
                      setState(() {
                        submitText = newValue;
                      });
                    }),
                TextButton(
                    child: Text('Init'),
                    onPressed: () async {
                      await entityExtractor.init();
                    }),
                TextButton(
                    child: Text('Extract Entities from Text'),
                    onPressed: () async {
                      await entityExtractor.init();
                      List<EntityAnnotation> res =
                          await entityExtractor.annotate(submitText);
                      print(results);
                      print(res);
                      for (EntityAnnotation eA in res) {
                        print(eA.annotatedText);
                        for (Entity e in eA.entities) {
                          print(e.type.toString());
                          if (e.type == EntityType.tracking_number) {
                            print(e.parcelCarrier);
                            print(e.parcelTrackingNumber);
                          }
                        }
                      }
                      setState(() {
                        results = res;
                      });
                    }),
                results != null &&
                        results.length > 0 &&
                        results[0].entities != null &&
                        results[0].entities.length > 0
                    ? Text(results[0].entities[0].type.toString())
                    : Container(),
              ]),
        ),
      ),
    );
  }
}
