package com.brianmtully.flutter.plugins.google_ml_nlp
import android.util.Log
import com.google.mlkit.nl.entityextraction.*
import io.flutter.plugin.common.MethodChannel

class GNLEntityExtractor {
    private val entityExtractor : EntityExtractor;

    private val TAG = "GNLEntityExtractor";


    constructor(options : HashMap<String, Any>) {
        entityExtractor = EntityExtraction.getClient(
                EntityExtractorOptions.Builder(EntityExtractorOptions.ENGLISH)
                        .build())
        entityExtractor
                .downloadModelIfNeeded()
                .addOnSuccessListener { _ ->
                    /* Model downloading succeeded, you can call extraction API here. */
                }
                .addOnFailureListener { _ -> /* Model downloading failed. */ }
    }

    fun close(result : MethodChannel.Result) {
        entityExtractor.close()
        result.success(true)
    }

    fun annotate(options : HashMap<String, Any>, result : MethodChannel.Result) {
        val params =
                EntityExtractionParams.Builder(options.get("text") as String)
                        //.setEntityTypesFilter((/* optional entity type filter */)
                        // .setPreferredLocale(/* optional preferred locale */)
                        //      .setReferenceTime(/* optional reference date-time */)
                        //     .setReferenceTimeZone(/* optional reference timezone */)
                        .build()
        var results = mutableListOf<HashMap<String,Any>>();
            entityExtractor
                    .annotate(params)
                    .addOnSuccessListener { entityAnnotations ->
                        for (entityAnnotation in entityAnnotations) {
                            val entities: List<Entity> = entityAnnotation.entities
                            var resEntityAnnotation = HashMap<String, Any>()
                            resEntityAnnotation["annotatedText"] = entityAnnotation.annotatedText
                            resEntityAnnotation["start"] = entityAnnotation.start
                            resEntityAnnotation["end"] = entityAnnotation.end
                            var resEntities = mutableListOf<HashMap<String,Any>>()
                            // Log.d("text", entityAnnotation.annotatedText)
                            for (entity in entities) {
                                var resEntity = HashMap<String, Any>()
                                resEntity["type"] = entity.type;
                                /*resEntity["text"] = entityAnnotation.annotatedText
                                resEntity["start"] = entityAnnotation.start
                                resEntity["end"] = entityAnnotation.end*/
                                when (entity) {
                                    is DateTimeEntity -> {
                                        resEntity["dateTimeGranularity"] = entity.dateTimeGranularity + 1
                                        resEntity["timestampMillis"] = entity.timestampMillis
                                    }
                                    is FlightNumberEntity -> {
                                        resEntity["airlineCode"] = entity.airlineCode
                                        resEntity["flightNumber"] = entity.flightNumber
                                    }
                                    is MoneyEntity -> {
                                        resEntity["unnormalizedCurrency"] = entity.unnormalizedCurrency
                                        resEntity["integerPart"] = entity.integerPart
                                        resEntity["fractionalPart"] = entity.fractionalPart
                                    }
                                    is TrackingNumberEntity -> {
                                        resEntity["parcelCarrier"] = entity.parcelCarrier
                                        resEntity["parcelTrackingNumber"] = entity.parcelTrackingNumber
                                    }
                                    is IbanEntity -> {
                                        resEntity["iban"] = entity.iban
                                        resEntity["ibanCountryCode"] = entity.ibanCountryCode
                                    }
                                    is IsbnEntity -> {
                                        resEntity["isbn"] = entity.isbn
                                    }
                                    is PaymentCardEntity -> {
                                        resEntity["paymentCardNetwork"] = entity.paymentCardNetwork
                                        resEntity["paymentCardNumber"] = entity.paymentCardNumber
                                    }
                                    else -> {
                                        // Log.d(TAG, "  $entity")
                                    }
                                }
                                resEntities.add(resEntity);
                            }
                            resEntityAnnotation["entities"] = resEntities;
                            results.add(resEntityAnnotation);
                        }
                        result.success(results);
                    }
                    .addOnFailureListener {
                        // Check failure message here.
                        result.error("Failure","Failure","Failure")
                    }
    }

}