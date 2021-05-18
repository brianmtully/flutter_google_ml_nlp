# Google ML Kit Natural Language Processing (NLP) Plugin

(https://pub.dev/packages/google_ml_nlp)

A Flutter plugin to use the capabilities of on-device Google ML Kit Natural Language Processing APIs

## Usage

To use this plugin, add `google_ml_nlp` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).


## Using an Entity Extractor

### 1. Import `google_ml_nlp`.

```dart
import 'package:google_ml_nlp/google_ml_nlp.dart';
```


### 2. Create and initialize your `EntityExtractor`.

```dart
EntityExtractor entityExtractor = GoogleNLP.instance.entityExtractor();
await entityExtractor.init();
```

### 3. Annotate text

```dart
List<EntityAnnotation> res = await entityExtractor.annotate(submitText);
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
```

## Getting Started

See the `example` directory for a complete sample app using Google ML Kit NLP.
