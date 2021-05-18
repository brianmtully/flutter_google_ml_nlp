// @dart=2.12
part of google_ml_nlp;

enum DateTimeGranularity {
  /// The granularity of the DateTimeEntity is unknown - 0.
  unknown,

  /// The DateTimeEntity is precise to a specific year - 1.
  year,

  /// The DateTimeEntity is precise to a specific month - 2.
  month,

  /// The DateTimeEntity is precise to a specific week - 3.
  week,

  /// The DateTimeEntity is precise to a specific day - 4.
  day,

  /// The DateTimeEntity is precise to a specific hour - 5.
  hour,

  /// The DateTimeEntity is precise to a specific minute - 6.
  minute,

  /// The DateTimeEntity is precise to a specific second - 7.
  second,
}

enum ParcelTrackingCarrier {
  /// The parcel tracking carrier is unknown - 0.
  unknown,

  /// The parcel tracking carrier is FedEx - 1.
  fedEx,

  /// The parcel tracking carrier is UPS - 2.
  UPS,

  /// The parcel tracking carrier is DHL - 3.
  DHL,

  /// The parcel tracking carrier is USPS - 4.
  USPS,

  /// The parcel tracking carrier is Ontrac - 5.
  ontrac,

  /// The parcel tracking carrier is Lasership - 6.
  lasership,

  /// The parcel tracking carrier is IsraelPost - 7.
  israelPost,

  /// The parcel tracking carrier is SwissPost - 8.
  swissPost,

  /// The parcel tracking carrier is MSC - 9.
  MSC,

  /// The parcel tracking carrier is Amazon - 10.
  amazon,

  /// The parcel tracking carrier is IParcel - 11.
  iParcel,
}

enum PaymentCardNetwork {
  /// The payment card network is unknown - 0.
  unknown,

  /// The payment card is part of the Amex network - 1.
  amex,

  /// The payment card is part of the DinersClub network - 2.
  dinersClub,

  /// The payment card is part of the Discover network - 3.
  discover,

  /// The payment card is part of the InterPayment network - 4.
  interPayment,

  /// The payment card is part of the JCB network - 5.
  JCB,

  /// The payment card is part of the Maestro network - 6.
  maestro,

  /// The payment card is part of the Mastercard network - 7.
  mastercard,

  /// The payment card is part of the Mir network - 8.
  mir,

  /// The payment card is part of the Troy network - 9.
  troy,

  /// The payment card is part of the Unionpay network - 10.
  unionpay,

  /// The payment card is part of the Visa network -11.
  visa,
}

enum EntityType {
  /// Identifies a physical address - 1.
  address,

  /// Identifies a time reference that includes a specific time - 2.
  datetime,

  /// Identifies an email address - 3.
  email,

  /// Identifies a flight number in IATA format - 4.
  flight,

  /// Identifies an International Bank Account Number(IBAN) - 5.
  iban,

  /// Identifies an International Standard Book Number(ISBN) - 6.
  isbn,

  /// Identifies a payment card - 7.
  payment_card,

  /// Identifies a phone number - 8.
  phone,

  /// Identifies a tracking number - 9.
  tracking_number,

  /// Identifies a url - 10.
  url,

  /// Identifies an amount of money - 11.
  money,
}

class EntityExtractor {
  EntityExtractor._(this.options, this._handle) : assert(options != null);

  /// The options for the entity extractor.
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
    return _hasBeenOpened;
  }

  /// annotates.
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
    for (final dynamic data in reply) {
      annotations.add(EntityAnnotation._(data));
    }

    return annotations;
  }

  /// Release resources used by entity extractor.
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
  const EntityExtractorOptions({
    this.language = 'english',
  });

  final String language;
}

class EntityAnnotation {
  EntityAnnotation._(dynamic data)
      : _entities = data['entities'] == null
            ? null
            : List<Entity>.unmodifiable(
                data['entities'].map<Entity>((dynamic item) => Entity._(item))),
        annotatedText = data['annotatedText'],
        start = data['start'],
        end = data['end'];

  final String annotatedText;

  final int start;

  final int end;

  final List<Entity>? _entities;

  List<Entity>? get entities => _entities;
}

class Entity {
  Entity(
      {this.type,
      this.dateTimeGranularity,
      this.dateTime,
      this.airlineCode,
      this.flightNumber,
      this.unnormalizedCurrency,
      this.integerPart,
      this.fractionalPart,
      this.parcelCarrier,
      this.parcelTrackingNumber,
      this.countryCode,
      this.iban,
      this.isbn,
      this.paymentCardNetwork,
      this.paymentCardNumber});

  Entity._(dynamic data)
      : type = data["type"] == null
            ? null
            : data["type"].runtimeType == int
                ? EntityType.values[data['type'] - 1]
                : EntityType.values.firstWhere(
                    (e) => e.toString() == 'EntityType.' + data['type']),
        // dateTime
        dateTimeGranularity = data["dateTimeGranularity"] == null
            ? null
            : data["dateTimeGranularity"].runtimeType == int
                ? DateTimeGranularity.values[data['dateTimeGranularity']]
                : DateTimeGranularity.values.firstWhere((e) =>
                    e.toString() ==
                    'DateTimeGranularity.' + data['dateTimeGranularity']),
        dateTime = data['dateTime'] == null ? null : data['dateTime'],
        // flightNumber
        airlineCode = data['airlineCode'] == null ? null : data['airlineCode'],
        flightNumber =
            data['flightNumber'] == null ? null : data['flightNumber'],
        // money
        unnormalizedCurrency = data["unnormalizedCurrency"] == null
            ? null
            : data["unnormalizedCurrency"],
        integerPart = data["integerPart"] == null ? null : data["integerPart"],
        fractionalPart =
            data["fractionalPart"] == null ? null : data["fractionalPart"],
        // trackingNumber
        parcelCarrier = data["parcelCarrier"] == null
            ? null
            : data["parcelCarrier"].runtimeType == int
                ? ParcelTrackingCarrier.values[data['parcelCarrier']]
                : ParcelTrackingCarrier.values.firstWhere((e) =>
                    e.toString() ==
                    'ParcelTrackingCarrier.' + data['parcelCarrier']),
        parcelTrackingNumber = data["parcelTrackingNumber"] == null
            ? null
            : data["parcelTrackingNumber"],
        // iban
        countryCode = data["countryCode"] == null ? null : data["countryCode"],
        iban = data["iban"] == null ? null : data["iban"],
        // isbn
        isbn = data["isbn"] == null ? null : data["isbn"],
        // paymentCard
        paymentCardNetwork = data["paymentCardNetwork"] == null
            ? null
            : data["paymentCardNetwork"].runtimeType == int
                ? PaymentCardNetwork.values[data['paymentCardNetwork']]
                : PaymentCardNetwork.values.firstWhere((e) =>
                    e.toString() ==
                    'PaymentCardNetwork.' + data['paymentCardNetwork']),
        paymentCardNumber = data["paymentCardNumber"] == null
            ? null
            : data["paymentCardNumber"];

  final EntityType? type;
  final DateTimeGranularity? dateTimeGranularity;
  final double? dateTime;
  final String? airlineCode;
  final String? flightNumber;
  final String? unnormalizedCurrency;
  final int? integerPart;
  final int? fractionalPart;
  final ParcelTrackingCarrier? parcelCarrier;
  final String? parcelTrackingNumber;
  final String? countryCode;
  final String? iban;
  final String? isbn;
  final PaymentCardNetwork? paymentCardNetwork;
  final String? paymentCardNumber;
}
