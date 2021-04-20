#import "FlutterGoogleMlNlpPlugin.h"
#if __has_include(<google_ml_nlp/google_ml_nlp-Swift.h>)
#import <google_ml_nlp/google_ml_nlp-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "google_ml_nlp-Swift.h"
#endif

@implementation FlutterGoogleMlNlpPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterGoogleMlNlpPlugin registerWithRegistrar:registrar];
}
@end
