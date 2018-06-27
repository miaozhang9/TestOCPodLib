/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "QHGeoLocationPlugin.h"
#import "QHAlertManager.h"

#pragma mark Constants

#define kPGLocationErrorDomain @"kPGLocationErrorDomain"
#define kPGLocationDesiredAccuracyKey @"desiredAccuracy"
#define kPGLocationForcePromptKey @"forcePrompt"
#define kPGLocationDistanceFilterKey @"distanceFilter"
#define kPGLocationFrequencyKey @"frequency"

#pragma mark -
#pragma mark Categories



@implementation QHLocationData

@synthesize locationStatus, locationInfo, locationCallbacks, watchCallbacks;
- (QHLocationData*)init
{
    self = (QHLocationData*)[super init];
    if (self) {
        self.locationInfo = nil;
        self.locationCallbacks = nil;
        self.watchCallbacks = nil;
    }
    return self;
}

@end

#pragma mark -
#pragma mark QHLocation

@interface QHGeoLocationPlugin ()

@property (nonatomic, strong) NSString *authorStatusMessage;
@property (nonatomic, strong) NSString *locationStatusMessage;

@end
@implementation QHGeoLocationPlugin

@synthesize locationManager, locationData;

- (void)pluginInitialize
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self; // Tells the location manager to send updates to this object
    __locationStarted = NO;
    __highAccuracyEnabled = NO;
    _showAlertSetting = YES;
    self.locationData = nil;
}

- (BOOL)isAuthorized
{
    BOOL authorizationStatusClassPropertyAvailable = [CLLocationManager respondsToSelector:@selector(authorizationStatus)]; // iOS 4.2+

    if (authorizationStatusClassPropertyAvailable) {
        NSUInteger authStatus = [CLLocationManager authorizationStatus];
#ifdef __IPHONE_8_0
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {  //iOS 8.0+
            return (authStatus == kCLAuthorizationStatusAuthorizedWhenInUse) || (authStatus == kCLAuthorizationStatusAuthorizedAlways) || (authStatus == kCLAuthorizationStatusNotDetermined);
        }
#endif
        return (authStatus == kCLAuthorizationStatusAuthorizedAlways) || (authStatus == kCLAuthorizationStatusNotDetermined);
    }

    // by default, assume YES (for iOS < 4.2)
    return YES;
}

- (BOOL)isLocationServicesEnabled
{
    BOOL locationServicesEnabledInstancePropertyAvailable = [self.locationManager respondsToSelector:@selector(locationServicesEnabled)]; // iOS 3.x
    BOOL locationServicesEnabledClassPropertyAvailable = [CLLocationManager respondsToSelector:@selector(locationServicesEnabled)]; // iOS 4.x

    if (locationServicesEnabledClassPropertyAvailable) { // iOS 4.x
        return [CLLocationManager locationServicesEnabled];
    } else {
        return NO;
    }
}

- (void)startLocation:(BOOL)enableHighAccuracy
{
    if (![self isLocationServicesEnabled]) {
        [self returnLocationError:QHPERMISSIONDENIED withMessage:@"Location services are not enabled."];
        return;
    }
    if (![self isAuthorized]) {
        NSString* message = nil;
        BOOL authStatusAvailable = [CLLocationManager respondsToSelector:@selector(authorizationStatus)]; // iOS 4.2+
        if (authStatusAvailable) {
            NSUInteger code = [CLLocationManager authorizationStatus];
            if (code == kCLAuthorizationStatusNotDetermined) {
                // could return POSITION_UNAVAILABLE but need to coordinate with other platforms
                message = @"User undecided on application's use of location services.";
                
            } else if (code == kCLAuthorizationStatusRestricted) {
                message = @"Application's use of location services is restricted.";
            }
        }
        
        // PERMISSIONDENIED is only PositionError that makes sense when authorization denied
        [self returnLocationError:QHPERMISSIONDENIED withMessage:message];
        if (_showAlertSetting) {
            [self alertSetAuthorizationWithMessage:self.authorStatusMessage?self.authorStatusMessage:@"为便于您的贷款申请，请打开GPS定位和相机权限"];
            // @"请在设备的\"设置-隐私-定位服务\"中允许使用定位服务。"
        }
        _showAlertSetting = YES;
        return;
    }
    _showAlertSetting = NO;
#ifdef __IPHONE_8_0
    NSUInteger code = [CLLocationManager authorizationStatus];
    if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) { //iOS8+
        __highAccuracyEnabled = enableHighAccuracy;
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]){
            [self.locationManager requestWhenInUseAuthorization];
        } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]) {
            [self.locationManager  requestAlwaysAuthorization];
        } else {
            NSLog(@"[Warning] No NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription key is defined in the Info.plist file.");
        }
        return;
    }
#endif

    // Tell the location manager to start notifying us of location updates. We
    // first stop, and then start the updating to ensure we get at least one
    // update, even if our location did not change.
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startUpdatingLocation];
    __locationStarted = YES;
    if (enableHighAccuracy) {
        __highAccuracyEnabled = YES;
        // Set distance filter to 5 for a high accuracy. Setting it to "kCLDistanceFilterNone" could provide a
        // higher accuracy, but it's also just spamming the callback with useless reports which drain the battery.
        self.locationManager.distanceFilter = 5;
        // Set desired accuracy to Best.
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    } else {
        __highAccuracyEnabled = NO;
        self.locationManager.distanceFilter = 10;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    }
}

- (void)alertSetAuthorizationWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        QHAlertManager *alertManager = [QHAlertManager shareAlertManager];
        alertManager.viewController = self.viewController;
        [alertManager showAlertMessageWithMessage:message];
    });
}


- (void)_stopLocation
{
    if (__locationStarted) {
        if (![self isLocationServicesEnabled]) {
            return;
        }

        [self.locationManager stopUpdatingLocation];
        __locationStarted = NO;
        __highAccuracyEnabled = NO;
    }
}

- (void)locationManager:(CLLocationManager*)manager
    didUpdateToLocation:(CLLocation*)newLocation
           fromLocation:(CLLocation*)oldLocation
{
    QHLocationData* cData = self.locationData;

    cData.locationInfo = newLocation;
    if (self.locationData.locationCallbacks.count > 0) {
        for (NSString* callbackId in self.locationData.locationCallbacks) {
            [self returnLocationInfo:callbackId andKeepCallback:NO];
        }

        [self.locationData.locationCallbacks removeAllObjects];
    }
    if (self.locationData.watchCallbacks.count > 0) {
        for (NSString* timerId in self.locationData.watchCallbacks) {
            [self returnLocationInfo:[self.locationData.watchCallbacks objectForKey:timerId] andKeepCallback:YES];
        }
    } else {
        // No callbacks waiting on us anymore, turn off listening.
        [self _stopLocation];
    }
}

- (void)getLocation:(QHInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        NSString* callbackId = command.callbackId;
        BOOL enableHighAccuracy = [[command argumentAtIndex:0] boolValue];
        self.locationStatusMessage = [command argumentAtIndex:2] ;
        self.authorStatusMessage =  [command argumentAtIndex:3] ;
        
        if ([self isLocationServicesEnabled] == NO) {
         
            
            NSMutableDictionary* posError = [NSMutableDictionary dictionaryWithCapacity:2];
            [posError setObject:[NSNumber numberWithInt:QHPERMISSIONDENIED] forKey:@"code"];
            [posError setObject:@"Location services are disabled." forKey:@"message"];
            QHPluginResult* result = [QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageAsDictionary:posError];
            [self.commandDelegate sendPluginResult:result callbackId:callbackId];
//
            
//            //请打开系统的\"设置-隐私-定位服务  先不删除
//            dispatch_after(0.0, dispatch_get_main_queue(), ^{
//                self.locationManager = [[CLLocationManager alloc]init];
//                [self.locationManager requestAlwaysAuthorization];
//                
//            });
            
            [QHAlertManager shareAlertManager].viewController = self.viewController;
            [[QHAlertManager shareAlertManager] showAlertMessage:self.locationStatusMessage?self.locationStatusMessage:@"为便于您的贷款申请，请打开GPS定位和相机权限"];//为便于您的贷款申请，请打开\"设置-隐私-定位服务\"
 
            // 暂时添加只获取定位一次
             [self _stopLocation];
        } else {
            if (!self.locationData) {
                self.locationData = [[QHLocationData alloc] init];
            }
            QHLocationData* lData = self.locationData;
            if (!lData.locationCallbacks) {
                lData.locationCallbacks = [NSMutableArray arrayWithCapacity:1];
            }

            if (!__locationStarted || (__highAccuracyEnabled != enableHighAccuracy)) {
                // add the callbackId into the array so we can call back when get data
                if (callbackId != nil) {
                    [lData.locationCallbacks addObject:callbackId];
                }
                // Tell the location manager to start notifying us of heading updates
                [self startLocation:enableHighAccuracy];
            } else {
                [self returnLocationInfo:callbackId andKeepCallback:NO];
            }
        }
    }];
}

- (void)addWatch:(QHInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;
    NSString* timerId = [command argumentAtIndex:0];
    BOOL enableHighAccuracy = [[command argumentAtIndex:1] boolValue];

    if (!self.locationData) {
        self.locationData = [[QHLocationData alloc] init];
    }
    QHLocationData* lData = self.locationData;

    if (!lData.watchCallbacks) {
        lData.watchCallbacks = [NSMutableDictionary dictionaryWithCapacity:1];
    }

    // add the callbackId into the dictionary so we can call back whenever get data
    [lData.watchCallbacks setObject:callbackId forKey:timerId];

    if ([self isLocationServicesEnabled] == NO) {
        NSMutableDictionary* posError = [NSMutableDictionary dictionaryWithCapacity:2];
        [posError setObject:[NSNumber numberWithInt:QHPERMISSIONDENIED] forKey:@"code"];
        [posError setObject:@"Location services are disabled." forKey:@"message"];
        QHPluginResult* result = [QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageAsDictionary:posError];
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    } else {
        if (!__locationStarted || (__highAccuracyEnabled != enableHighAccuracy)) {
            // Tell the location manager to start notifying us of location updates
            [self startLocation:enableHighAccuracy];
        }
    }
}

- (void)clearWatch:(QHInvokedUrlCommand*)command
{
    NSString* timerId = [command argumentAtIndex:0];

    if (self.locationData && self.locationData.watchCallbacks && [self.locationData.watchCallbacks objectForKey:timerId]) {
        [self.locationData.watchCallbacks removeObjectForKey:timerId];
        if([self.locationData.watchCallbacks count] == 0) {
            [self _stopLocation];
        }
    }
}

- (void)stopLocation:(QHInvokedUrlCommand*)command
{
    [self _stopLocation];
}

- (void)returnLocationInfo:(NSString*)callbackId andKeepCallback:(BOOL)keepCallback
{
    __block QHPluginResult *result = nil;
    QHLocationData *lData = self.locationData;

    if (lData && !lData.locationInfo) {
        // return error
        result = [QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageToErrorObject:QHPOSITIONUNAVAILABLE];
        if (result) {
            [self.commandDelegate sendPluginResult:result callbackId:callbackId];
        }
    } else if (lData && lData.locationInfo) {
        // 保存 Device 的现语言 (英语 法语 ，，，)
        NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                                                objectForKey:@"AppleLanguages"];
        // 强制 成 简体中文
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil]
                                                  forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        CLLocation* lInfo = lData.locationInfo;
        NSMutableDictionary* returnInfo = [NSMutableDictionary dictionary];
        NSNumber* timestamp = [NSNumber numberWithDouble:([lInfo.timestamp timeIntervalSince1970] * 1000)];
        [returnInfo setObject:timestamp forKey:@"timestamp"];
        [returnInfo setObject:[NSNumber numberWithDouble:lInfo.speed] forKey:@"velocity"];
        [returnInfo setObject:[NSNumber numberWithDouble:lInfo.verticalAccuracy] forKey:@"altitudeAccuracy"];
        [returnInfo setObject:[NSNumber numberWithDouble:lInfo.horizontalAccuracy] forKey:@"accuracy"];
        [returnInfo setObject:[NSNumber numberWithDouble:lInfo.course] forKey:@"heading"];
        [returnInfo setObject:[NSNumber numberWithDouble:lInfo.altitude] forKey:@"altitude"];
        [returnInfo setObject:[NSNumber numberWithDouble:lInfo.coordinate.latitude] forKey:@"latitude"];
        [returnInfo setObject:[NSNumber numberWithDouble:lInfo.coordinate.longitude] forKey:@"longitude"];

        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:[[NSNumber numberWithDouble:lInfo.coordinate.latitude] doubleValue] longitude:[[NSNumber numberWithDouble:lInfo.coordinate.longitude] doubleValue] ];
        
        CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
        [clGeoCoder reverseGeocodeLocation:newLocation completionHandler: ^(NSArray *placemarks,NSError *error) {
            if (placemarks.count > 0) {
                CLPlacemark *placeMark = placemarks[0];
                NSDictionary *addressDic = placeMark.addressDictionary;
        
                NSString *state=[addressDic objectForKey:@"State"];
                NSString *city=[addressDic objectForKey:@"City"];
                NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
                NSString *street=[addressDic objectForKey:@"Street"];
                
                [returnInfo setObject:(state?state:@"") forKey:@"state"];
                [returnInfo setObject:(city?city:@"") forKey:@"city"];
                [returnInfo setObject:(subLocality?subLocality:@"") forKey:@"subLocality"];
                [returnInfo setObject:(street?street:@"") forKey:@"street"];
            }
            result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsDictionary:returnInfo];
            [result setKeepCallbackAsBool:keepCallback];
            
            // 还原Device 的语言
            [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
             [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (result) {
                [self.commandDelegate sendPluginResult:result callbackId:callbackId];
            }
        }];
    }
}

- (void)returnLocationError:(NSUInteger)QHErrorCode withMessage:(NSString*)message
{
    NSMutableDictionary* posError = [NSMutableDictionary dictionaryWithCapacity:2];

    [posError setObject:[NSNumber numberWithUnsignedInteger:QHErrorCode] forKey:@"code"];
    [posError setObject:message ? message:@"" forKey:@"message"];
    QHPluginResult* result = [QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageAsDictionary:posError];

    for (NSString* callbackId in self.locationData.locationCallbacks) {
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    }

    [self.locationData.locationCallbacks removeAllObjects];

    for (NSString* callbackId in self.locationData.watchCallbacks) {
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    }
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
    NSLog(@"locationManager::didFailWithError %@", [error localizedFailureReason]);

    QHLocationData* lData = self.locationData;
    if (lData && __locationStarted) {
        // TODO: probably have to once over the various error codes and return one of:
        // PositionError.PERMISSION_DENIED = 1;
        // PositionError.POSITION_UNAVAILABLE = 2;
        // PositionError.TIMEOUT = 3;
        NSUInteger positionError = QHPOSITIONUNAVAILABLE;
        if (error.code == kCLErrorDenied) {
            positionError = QHPERMISSIONDENIED;
        }
        [self returnLocationError:positionError withMessage:[error localizedDescription]];
    }

    if (error.code != kCLErrorLocationUnknown) {
      [self.locationManager stopUpdatingLocation];
      __locationStarted = NO;
    }
}

//iOS8+
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {
        _showAlertSetting = NO;
    }
    
    if(!__locationStarted){
        [self startLocation:__highAccuracyEnabled];
    }
    
}

- (void)dealloc
{
    self.locationManager.delegate = nil;
}

- (void)onReset
{
    [self _stopLocation];
    [self.locationManager stopUpdatingHeading];
}

@end