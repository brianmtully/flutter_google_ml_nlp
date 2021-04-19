package com.brianmtully.flutter.plugins.flutter_google_ml_nlp
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
                            Log.d("text", entityAnnotation.annotatedText)
                            for (entity in entities) {
                                var resEntity = HashMap<String, Any>()
                                resEntity["type"] = entity.type;
                                when (entity) {
                                    is DateTimeEntity -> {
                                        resEntity["dateTimeGranularity"] = entity.dateTimeGranularity
                                        resEntity["timestampMillis"] = entity.timestampMillis
                                        results.add(resEntity);
                                    }
                                    is FlightNumberEntity -> {
                                        resEntity["airlineCode"] = entity.airlineCode
                                        resEntity["flightNumber"] = entity.flightNumber
                                        results.add(resEntity);
                                    }
                                    is MoneyEntity -> {
                                        resEntity["unnormalizedCurrency"] = entity.unnormalizedCurrency
                                        resEntity["integerPart"] = entity.integerPart
                                        resEntity["fractionalPart"] = entity.fractionalPart
                                        results.add(resEntity);
                                    }
                                    is TrackingNumberEntity -> {
                                        resEntity["parcelCarrier"] = entity.parcelCarrier
                                        resEntity["parcelTrackingNumber"] = entity.parcelTrackingNumber
                                        results.add(resEntity);
                                    }
                                    else -> {
                                        Log.d(TAG, "  $entity")
                                    }
                                }
                            }
                        }
                        result.success(results);
                    }
                    .addOnFailureListener {
                        // Check failure message here.
                        result.error("Failure","Failure","Failure")
                    }
    }

}