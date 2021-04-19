//
//  GNLEntityExtractor.swift
//  flutter_google_ml_nlp
//
//  Created by Brian Tully on 4/17/21.
//

import Foundation
import MLKitEntityExtraction
import Flutter

class GNLEntityExtractor {
    private final var entityExtractor : EntityExtractor;
    
    init(options : Dictionary<String, Any>) {
        // Note: You can specify any of the 15 languages Entity Extraction supports here.
        let opts = EntityExtractorOptions(modelIdentifier:
                                            EntityExtractionModelIdentifier.english)
        
        entityExtractor = EntityExtractor.entityExtractor(options: opts)
        
        entityExtractor.downloadModelIfNeeded(completion: {_ in
          // If the error is nil, the download completed successfully.
        })
    }
    
    public func annotate(options: [String:Any] , result: @escaping FlutterResult) {
        // let opt : [String: Any] = options["options"]! as! [String : Any]
        //print(options)
        let text : String = options["text"]! as! String
        // The EntityExtractionParams parameter is optional. Only instantiate and
        // configure one if you need to customize one or more of its params.
        //var params = EntityExtractionParams()
        // The params object contains the following properties which can be customized on
        // each annotateText: call. Please see the class's documentation for a more
        // detailed description of what each property represents.
        //params.referenceTime = Date();
        //params.referenceTimeZone = TimeZone(identifier: "GMT");
        //params.preferredLocale = Locale(identifier: "en-US");
        //params.typesFilter = Set([EntityType.address, EntityType.dateTime])

        entityExtractor.annotateText(text,
          //  params: params,
            completion: {
              res, error in
              // If the error is nil, the annotation completed successfully and any results
              // will be contained in the `result` array.
                // let annotations be the Array! returned from EntityExtractor
                if (res != nil) {
                var returnValues = [[String:Any]]()
                for annotation in res! {
                  let entities = annotation.entities
                  for entity in entities {
                    var returnEntity = [String:Any]()
                    switch entity.entityType {
                      case EntityType.dateTime:
                        guard let dateTimeEntity = entity.dateTimeEntity else {
                          print("This field should be populated.")
                          return
                        }
                        returnEntity["dateTimeGranularity"] = dateTimeEntity.dateTimeGranularity.rawValue
                        returnEntity["dateTime"] = dateTimeEntity.dateTime.timeIntervalSince1970
                        returnValues.append(returnEntity)
                      case EntityType.flightNumber:
                        guard let flightNumberEntity = entity.flightNumberEntity else {
                          print("This field should be populated.")
                          return
                        }
                        returnEntity["airlineCode"] = flightNumberEntity.airlineCode
                        returnEntity["flightNumber"] = flightNumberEntity.flightNumber
                        returnValues.append(returnEntity)
                      case EntityType.money:
                        guard let moneyEntity = entity.moneyEntity else {
                          print("This field should be populated.")
                          return
                        }
                        returnEntity["unnormalizedCurrency"] = moneyEntity.unnormalizedCurrency
                        returnEntity["integerPart"] = moneyEntity.integerPart
                        returnEntity["fractionalPart"] = moneyEntity.fractionalPart
                        returnValues.append(returnEntity)
                      // Add additional cases as needed.
                    case EntityType.trackingNumber:
                        guard let trackingNumberEntity = entity.trackingNumberEntity else {
                          print("This field should be populated.")
                          return
                        }
                        returnEntity["parcelCarrier"] = trackingNumberEntity.parcelCarrier.rawValue
                        returnEntity["parcelTrackingNumber"] = trackingNumberEntity.parcelTrackingNumber
                        returnValues.append(returnEntity)
                      
                      default:
                        print("Entity: %@", entity);
                    }
                  }
                }
                result(returnValues)
              }
            }
        )
        
    }
}
