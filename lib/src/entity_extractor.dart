// @dart=2.9
part of google_ml_nlp;

class EntityExtractor {
  EntityExtractor._(this.options, this._handle) : assert(options != null);

  /// The options for the face detector.
  final EntityExtractorOptions options;
  final int _handle;
  bool _hasBeenOpened = false;
  bool _isClosed = false;

  Future<bool> init() async {
    _hasBeenOpened = await GoogleNLP.channel.invokeMethod<dynamic>(
      'EntityExtractor#init',
      <String, dynamic>{
        'handle': _handle,
        'options': {},
      },
    );
  }

  /// Detects faces in the input image.
  Future<List> annotate(String text) async {
    assert(!_isClosed);
    assert(_hasBeenOpened);
    //_hasBeenOpened = true;
    final List reply = await GoogleNLP.channel.invokeMethod<dynamic>(
      'EntityExtractor#annotate',
      <String, dynamic>{
        'handle': _handle,
        'options': {'text': text}
      },
    );

    final List<EntityAnnotation> annotations = <EntityAnnotation>[];
    /*for (final dynamic data in reply) {
      annotations.add(EntityAnnotation._(data));
    }*/

    return reply;
  }

  /// Release resources used by this detector.
  Future<void> close() {
    if (!_hasBeenOpened) _isClosed = true;
    if (_isClosed) return Future<void>.value();

    _isClosed = true;
    return GoogleNLP.channel.invokeMethod<void>(
      'EntityExtractor#close',
      <String, dynamic>{'handle': _handle},
    );
  }
}

class EntityExtractorOptions {
  /// Constructor for [EntityExtractorOptions].
  ///
  /// The parameter minFaceValue must be between 0.0 and 1.0, inclusive.
  const EntityExtractorOptions({
    this.language = 'english',
  });

  final String language;
}

class EntityAnnotation {
  EntityAnnotation._(dynamic data) : _entities = data['entities'];

  final List<Entity> _entities;
}

class Entity {
  Entity._(dynamic data);
}
