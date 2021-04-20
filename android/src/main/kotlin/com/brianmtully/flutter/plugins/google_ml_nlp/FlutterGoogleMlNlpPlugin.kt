package com.brianmtully.flutter.plugins.google_ml_nlp

import androidx.annotation.NonNull
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import com.google.mlkit.nl.entityextraction.*


/** FlutterGoogleMlNlpPlugin */
class FlutterGoogleMlNlpPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private val TAG = "google_ml_np"
  private lateinit var entityExtractor : GNLEntityExtractor

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugins.flutter.brianmtully.com/google_ml_nlp")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "EntityExtractor#init") {
      var options : HashMap<String, Any> = call.argument("options")!!
      entityExtractor = GNLEntityExtractor(options)
      result.success(true)
    }
    else if (call.method == "EntityExtractor#annotate") {
      var options : HashMap<String, Any>? = call.argument("options")
      options?.let { entityExtractor.annotate(it, result) }
    }
    else if (call.method == "EntityExtractor#close") {
      entityExtractor.close(result)
    }
    else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
