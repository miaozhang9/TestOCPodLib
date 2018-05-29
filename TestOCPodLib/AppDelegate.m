//
//  AppDelegate.m
//  TestOCPodLib
//
//  Created by Miaoz on 2018/5/11.
//  Copyright © 2018年 Miaoz. All rights reserved.
//

#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <Flutter/Flutter.h>



@interface AppDelegate ()
//1.先全局定义个Channel属性
@property(nonatomic, strong)FlutterMethodChannel *batteryChannel;
@end

@implementation AppDelegate
- (int)pay {
    int ran = arc4random() % 100;
    return ran;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    //2.创建MethodChannel对应flutter与原生
    self.batteryChannel = [FlutterMethodChannel
                                            methodChannelWithName:@"samples.flutter.io/pay"
                                            binaryMessenger:controller];
    //3.flutter动作触发及回调
    [self.batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        //支付method
        if ([@"pay" isEqualToString:call.method]) {
          //在这里去调用支付的方法
            //例如调用aliPaySDK
            [self aliPayinit];
            
            result(nil);
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
    

    
   
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];

//    return YES;
}

- (void)aliPayinit {
    //aiPay的sdk在这里写
}


//比如说这个就是你支付完成后支付宝回调给你成功失败的方法
- (void)aliPaySuccess:(BOOL) isSuccess error:(NSString *)error dataInfo:(NSDictionary *)dic {
    
    //这时候调用这个会回调给你flutter
    [self.batteryChannel send:"pay"];
    
    
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
