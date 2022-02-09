#import "LemmaSdkPlugin.h"
#if __has_include(<lemma_sdk/lemma_sdk-Swift.h>)
#import <lemma_sdk/lemma_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "lemma_sdk-Swift.h"
#endif


@implementation LemmaSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLemmaSdkPlugin registerWithRegistrar:registrar];
}

+ (UIViewController *)rootVC {
    UIViewController *rootController =
    UIApplication.sharedApplication.delegate.window.rootViewController;
    return rootController;
}
@end
