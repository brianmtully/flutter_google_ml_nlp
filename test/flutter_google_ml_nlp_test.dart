import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_ml_nlp/google_ml_nlp.dart';

void main() {
  const MethodChannel channel =
      MethodChannel('plugins.flutter.brianmtully.com/google_ml_nlp');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('EntityExtractor', () async {
    EntityExtractor extractor = GoogleNLP.instance.entityExtractor();

    expect(await extractor.annotate("My Text"), 'noun');
  });
}
