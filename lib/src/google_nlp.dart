// @dart=2.9
part of google_ml_nlp;

class GoogleNLP {
  GoogleNLP._();

  @visibleForTesting
  static const MethodChannel channel =
      MethodChannel('plugins.flutter.brianmtully.com/google_ml_nlp');

  @visibleForTesting
  static int nextHandle = 0;

  static final GoogleNLP instance = GoogleNLP._();

  static Future<String> get platformVersion async {
    final String version = await channel.invokeMethod('getPlatformVersion');
    return version;
  }

  EntityExtractor entityExtractor([EntityExtractorOptions options]) {
    return EntityExtractor._(
      options ?? const EntityExtractorOptions(),
      nextHandle++,
    );
  }
}

String _enumToString(dynamic enumValue) {
  final String enumString = enumValue.toString();
  return enumString.substring(enumString.indexOf('.') + 1);
}
