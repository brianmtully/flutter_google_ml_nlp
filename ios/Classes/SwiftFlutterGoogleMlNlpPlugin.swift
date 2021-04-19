import Flutter
import UIKit

public class SwiftFlutterGoogleMlNlpPlugin: NSObject, FlutterPlugin {
    
    private var entityExtractor : GNLEntityExtractor?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "plugins.flutter.brianmtully.com/google_ml_nlp", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterGoogleMlNlpPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args : [String : Any] = (call.arguments as! [String : Any]?) else {
      result("iOS could not recognize flutter arguments in method: (sendParams)")
        return
    }
    if call.method == "getPlatformVersion" {
        result("iOS " + UIDevice.current.systemVersion)
    }
    else if call.method == "EntityExtractor#init" {
        let options : [String:Any] = args["options"] as? [String:Any] ?? ["language" : "English"]
        entityExtractor = GNLEntityExtractor(options: options)
        result(true)
    }
    else if call.method == "EntityExtractor#annotate" {
        let options : [String:Any] = args["options"] as? [String:Any] ?? ["text" : "test"]
        entityExtractor?.annotate(options: options, result: result);
    }
    else {
        result(FlutterMethodNotImplemented)
        return
    }
  }
}
