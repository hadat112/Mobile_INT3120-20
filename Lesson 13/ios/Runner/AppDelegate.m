#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
   didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

   // custom code starts
   FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
   FlutterMethodChannel* browserChannel = [
      FlutterMethodChannel methodChannelWithName:
      @"flutterapp.tutorialspoint.com/browser" binaryMessenger:controller];

   __weak typeof(self) weakSelf = self;
   [browserChannel setMethodCallHandler:^(
      FlutterMethodCall* call, FlutterResult result) {

      if ([@"openBrowser" isEqualToString:call.method]) {
         NSString *url = call.arguments[@"url"];
         [weakSelf openBrowser:url];
      } else { result(FlutterMethodNotImplemented); }
   }];
   // custom code ends
   [GeneratedPluginRegistrant registerWithRegistry:self];

   // Override point for customization after application launch.
   return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
- (void)openBrowser:(NSString *)urlString {
   NSURL *url = [NSURL URLWithString:urlString];
   UIApplication *application = [UIApplication sharedApplication];
   [application openURL:url];
}
@end
