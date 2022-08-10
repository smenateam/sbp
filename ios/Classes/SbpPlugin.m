#import "SbpPlugin.h"
#if __has_include(<sbp/sbp-Swift.h>)
#import <sbp/sbp-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "sbp-Swift.h"
#endif

@implementation SbpPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSbpPlugin registerWithRegistrar:registrar];
}
@end
