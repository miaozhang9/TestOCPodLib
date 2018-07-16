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

#import <objc/message.h>
#import "QH.h"
#import "QHPlugin+Private.h"
#import "QHUIWebViewDelegate.h"
#import "QHConfigParser.h"
#import "QHUserAgentUtil.h"
#import <AVFoundation/AVFoundation.h>
#import "NSDictionary+QHCordovaPreferences.h"
#import "QHLocalStorage.h"
#import "QHCommandDelegateImpl.h"
#import "QHLoanDoorBundle.h"
#import "QHInterceptProtocol.h"
#import "UIColor+QH.h"
#import "NSURLProtocol+WebKitSupport.h"
#import "QHLoanDoor.h"
#import <WebKit/WebKit.h>
@interface QHViewController () {
    NSInteger _userAgentLockToken;
}

@property (nonatomic, readwrite, strong) NSXMLParser* configParser;
@property (nonatomic, readwrite, strong) NSMutableDictionary* settings;
@property (nonatomic, readwrite, strong) NSMutableDictionary* pluginObjects;
@property (nonatomic, readwrite, strong) NSMutableArray* startupPluginNames;
@property (nonatomic, readwrite, strong) NSDictionary* pluginsMap;
@property (nonatomic, readwrite, strong) id <QHWebViewEngineProtocol> webViewEngine;

@property (readwrite, assign) BOOL initialized;

@property (atomic, strong) NSURL* openURL;




@end

@implementation QHViewController

@synthesize supportedOrientations;
@synthesize pluginObjects, pluginsMap, startupPluginNames;
@synthesize configParser, settings;
@synthesize wwwFolderName, startPage, initialized, openURL, baseUserAgent;
@synthesize commandDelegate = _commandDelegate;
@synthesize commandQueue = _commandQueue;
@synthesize webViewEngine = _webViewEngine;
@dynamic webView;

- (void)__init
{
    if ((self != nil) && !self.initialized) {
        _commandQueue = [[QHCommandQueue alloc] initWithViewController:self];
        _commandDelegate = [[QHCommandDelegateImpl alloc] initWithViewController:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillTerminate:)
                                                     name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification object:nil];

        // read from UISupportedInterfaceOrientations (or UISupportedInterfaceOrientations~iPad, if its iPad) from -Info.plist
        self.supportedOrientations = [self parseInterfaceOrientations:
            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISupportedInterfaceOrientations"]];

        [self printVersion];
        [self printMultitaskingInfo];
        [self printPlatformVersionWarning];
        self.initialized = YES;
        
        
    }
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self __init];
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self __init];
    return self;
}

- (id)init
{
    self = [super init];
    [self __init];
    return self;
}

- (void)printVersion
{
    NSLog(@"Apache Cordova native platform version %@ is starting.", QH_VERSION);
}

- (void)printPlatformVersionWarning
{
    if (!IsAtLeastiOSVersion(@"8.0")) {
        NSLog(@"CRITICAL: For Cordova 4.0.0 and above, you will need to upgrade to at least iOS 8.0 or greater. Your current version of iOS is %@.",
            [[UIDevice currentDevice] systemVersion]
            );
    }
}

- (void)printMultitaskingInfo
{
    UIDevice* device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;

    if ([device respondsToSelector:@selector(isMultitaskingSupported)]) {
        backgroundSupported = device.multitaskingSupported;
    }

    NSNumber* exitsOnSuspend = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIApplicationExitsOnSuspend"];
    if (exitsOnSuspend == nil) { // if it's missing, it should be NO (i.e. multi-tasking on by default)
        exitsOnSuspend = [NSNumber numberWithBool:NO];
    }

    NSLog(@"Multi-tasking -> Device: %@, App: %@", (backgroundSupported ? @"YES" : @"NO"), (![exitsOnSuspend intValue]) ? @"YES" : @"NO");
}

-(NSString*)configFilePath{
    NSString* path = self.configFile ?: @"config_loan.xml";

    // if path is relative, resolve it against the main bundle
    if(![path isAbsolutePath]){
        /*
        NSString* absolutePath = [[NSBundle mainBundle] pathForResource:path ofType:nil];
         */
        NSString* absolutePath = [QHLoanDoorBundle filePath:path];
        if(!absolutePath){
//            NSAssert(NO, @"ERROR: %@ not found in the main bundle!", path);
        }
        path = absolutePath;
    }

    // Assert file exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
//        NSAssert(NO, @"ERROR: %@ does not exist. Please run cordova-ios/bin/cordova_plist_to_config_loan_xml path/to/project.", path);
        return nil;
    }

    return path;
}

- (void)parseSettingsWithParser:(NSObject <NSXMLParserDelegate>*)delegate
{
    // read from config_loan.xml in the app bundle
    NSString* path = [self configFilePath];

    NSURL* url = [NSURL fileURLWithPath:path];

    self.configParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    if (self.configParser == nil) {
        NSLog(@"Failed to initialize XML parser.");
        return;
    }
    [self.configParser setDelegate:((id < NSXMLParserDelegate >)delegate)];
    [self.configParser parse];
}



- (void)loadSettings
{
    QHConfigParser* delegate = [[QHConfigParser alloc] init];

    [self parseSettingsWithParser:delegate];

    // Get the plugin dictionary, whitelist and settings from the delegate.
    self.pluginsMap = delegate.pluginsDict;
    self.startupPluginNames = delegate.startupPluginNames;
    self.settings = delegate.settings;

    // And the start folder/page.
//    if(self.wwwFolderName == nil){
//        self.wwwFolderName = @"www";
//    }
//    if(delegate.startPage && self.startPage == nil){
//        self.startPage = delegate.startPage;
//    }
//    if (self.startPage == nil) {
//        self.startPage = @"index.html";
//    }

    // Initialize the plugin objects dict.
    self.pluginObjects = [[NSMutableDictionary alloc] initWithCapacity:20];
}

- (NSURL*)appUrl
{
//    NSURL* appURL = nil;
//
//    if ([self.startPage rangeOfString:@"://"].location != NSNotFound) {
//        appURL = [NSURL URLWithString:self.startPage];
//    } else if ([self.wwwFolderName rangeOfString:@"://"].location != NSNotFound) {
//        appURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.wwwFolderName, self.startPage]];
//    } else if([self.wwwFolderName hasSuffix:@".bundle"]){
//        // www folder is actually a bundle
//        NSBundle* bundle = [NSBundle bundleWithPath:self.wwwFolderName];
//        appURL = [bundle URLForResource:self.startPage withExtension:nil];
//    } else if([self.wwwFolderName hasSuffix:@".framework"]){
//        // www folder is actually a framework
//        NSBundle* bundle = [NSBundle bundleWithPath:self.wwwFolderName];
//        appURL = [bundle URLForResource:self.startPage withExtension:nil];
//    } else {
//        // CB-3005 strip parameters from start page to check if page exists in resources
//        NSURL* startURL = [NSURL URLWithString:self.startPage];
//        NSString* startFilePath = [self.commandDelegate pathForResource:[startURL path]];
//
//        if (startFilePath == nil) {
//            appURL = nil;
//        } else {
//            appURL = [NSURL fileURLWithPath:startFilePath];
//            // CB-3005 Add on the query params or fragment.
//            NSString* startPageNoParentDirs = self.startPage;
//            NSRange r = [startPageNoParentDirs rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?#"] options:0];
//            if (r.location != NSNotFound) {
//                NSString* queryAndOrFragment = [self.startPage substringFromIndex:r.location];
//                appURL = [NSURL URLWithString:queryAndOrFragment relativeToURL:appURL];
//            }
//        }
//    }

    NSURL *appURL;

    if ([self.startPage isEqualToString:@"www/index.html"]) {
        NSString *filePath = [QHLoanDoorBundle filePath:@"www/index.html"];
        appURL = [NSURL fileURLWithPath:filePath];

    }
    else{
        appURL = [NSURL URLWithString:self.startPage && self.startPage.length > 0 ? self.startPage: nil];
    }

    return appURL;
}

- (NSURL*)errorURL
{
    NSURL* errorUrl = nil;

    id setting = [self.settings qh_cordovaSettingForKey:@"ErrorUrl"];

    if (setting) {
        NSString* errorUrlString = (NSString*)setting;
        if ([errorUrlString rangeOfString:@"://"].location != NSNotFound) {
            errorUrl = [NSURL URLWithString:errorUrlString];
        } else {
            NSURL* url = [NSURL URLWithString:(NSString*)setting];
            NSString* errorFilePath = [self.commandDelegate pathForResource:[url path]];
            if (errorFilePath) {
                errorUrl = [NSURL fileURLWithPath:errorFilePath];
            }
        }
    }

    return errorUrl;
}

- (UIView*)webView
{
    if (self.webViewEngine != nil) {
        return self.webViewEngine.engineWebView;
    }

    return nil;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    // 返回按钮 -- gpw
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, 60, 44);
    UIImage * bImage = [UIImage imageNamed:@"BarArrowLeft" inBundle:[QHLoanDoorBundle bundle] compatibleWithTraitCollection:nil];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 12);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [btn addTarget: self action: @selector(leftBarBtnAction) forControlEvents: UIControlEventTouchUpInside];
    [btn setImage: bImage forState: UIControlStateNormal];
    _backBtn = btn;
    UIBarButtonItem * lb = [[UIBarButtonItem alloc] initWithCustomView: btn];
    self.navigationItem.leftBarButtonItem = lb;
    
    UIButton * btn2 = [[UIButton alloc] init];
    btn2.hidden = YES;
    btn2.frame = CGRectMake(0, 0, 60, 44);
    [btn2 setTitle:@"完成" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:16];
    btn2.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
    [btn2 addTarget: self action: @selector(rightBarBtnAction) forControlEvents: UIControlEventTouchUpInside];
    _rightBtn = btn2;
    UIBarButtonItem * lb2 = [[UIBarButtonItem alloc] initWithCustomView: btn2];
    self.navigationItem.rightBarButtonItem = lb2;
    
    // Load settings
    [self loadSettings];

    NSString* backupWebStorageType = @"cloud"; // default value

    id backupWebStorage = [self.settings qh_cordovaSettingForKey:@"BackupWebStorage"];
    if ([backupWebStorage isKindOfClass:[NSString class]]) {
        backupWebStorageType = backupWebStorage;
    }
    [self.settings qh_setCordovaSetting:backupWebStorageType forKey:@"BackupWebStorage"];

    [QHLocalStorage __fixupDatabaseLocationsWithBackupType:backupWebStorageType];

    // // Instantiate the WebView ///////////////

    if (!self.webView) {
        [self createGapView];
    }

    // /////////////////

    /*
     * Fire up QHLocalStorage to work-around WebKit storage limitations: on all iOS 5.1+ versions for local-only backups, but only needed on iOS 5.1 for cloud backup.
        With minimum iOS 7/8 supported, only first clause applies.
     */
    if ([backupWebStorageType isEqualToString:@"local"]) {
        NSString* localStorageFeatureName = @"localstorage";
        if ([self.pluginsMap objectForKey:localStorageFeatureName]) { // plugin specified in config_loan
            [self.startupPluginNames addObject:localStorageFeatureName];
        }
    }

    if ([self.startupPluginNames count] > 0) {
        [QHTimer start:@"TotalPluginStartup"];

        for (NSString* pluginName in self.startupPluginNames) {
            [QHTimer start:pluginName];
            [self getCommandInstance:pluginName];
            [QHTimer stop:pluginName];
        }

        [QHTimer stop:@"TotalPluginStartup"];
    }

    // gpw --- 提取单独方法
    [self acquireUserAgentTorequestForWebView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:QHViewWillAppearNotification object:nil]];
    //add miaoz  必须放到这里，防止其他地方卸载影响
//     [[QHLoanDoor share] registerQHLoanSDKURLProtocol];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:QHViewDidAppearNotification object:nil]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:QHViewWillDisappearNotification object:nil]];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:QHViewDidDisappearNotification object:nil]];
    //add miaoz  必须放到这里，防止其他地方卸载影响
//        [[QHLoanDoor share] unRegisterQHLoanSDKURLProtocol];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:QHViewWillLayoutSubviewsNotification object:nil]];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:QHViewDidLayoutSubviewsNotification object:nil]];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:QHViewWillTransitionToSizeNotification object:[NSValue valueWithCGSize:size]]];
}

- (NSArray*)parseInterfaceOrientations:(NSArray*)orientations
{
    NSMutableArray* result = [[NSMutableArray alloc] init];

    if (orientations != nil) {
        NSEnumerator* enumerator = [orientations objectEnumerator];
        NSString* orientationString;

        while (orientationString = [enumerator nextObject]) {
            if ([orientationString isEqualToString:@"UIInterfaceOrientationPortrait"]) {
                [result addObject:[NSNumber numberWithInt:UIInterfaceOrientationPortrait]];
            } else if ([orientationString isEqualToString:@"UIInterfaceOrientationPortraitUpsideDown"]) {
                [result addObject:[NSNumber numberWithInt:UIInterfaceOrientationPortraitUpsideDown]];
            } else if ([orientationString isEqualToString:@"UIInterfaceOrientationLandscapeLeft"]) {
                [result addObject:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft]];
            } else if ([orientationString isEqualToString:@"UIInterfaceOrientationLandscapeRight"]) {
                [result addObject:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight]];
            }
        }
    }

    // default
    if ([result count] == 0) {
        [result addObject:[NSNumber numberWithInt:UIInterfaceOrientationPortrait]];
    }

    return result;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    NSUInteger ret = 0;

    if ([self supportsOrientation:UIInterfaceOrientationPortrait]) {
        ret = ret | (1 << UIInterfaceOrientationPortrait);
    }
    if ([self supportsOrientation:UIInterfaceOrientationPortraitUpsideDown]) {
        ret = ret | (1 << UIInterfaceOrientationPortraitUpsideDown);
    }
    if ([self supportsOrientation:UIInterfaceOrientationLandscapeRight]) {
        ret = ret | (1 << UIInterfaceOrientationLandscapeRight);
    }
    if ([self supportsOrientation:UIInterfaceOrientationLandscapeLeft]) {
        ret = ret | (1 << UIInterfaceOrientationLandscapeLeft);
    }

    return ret;
}

- (BOOL)supportsOrientation:(UIInterfaceOrientation)orientation
{
    return [self.supportedOrientations containsObject:[NSNumber numberWithInt:orientation]];
}

- (UIView*)newCordovaViewWithFrame:(CGRect)bounds
{
    NSString* defaultWebViewEngineClass = [self.settings qh_cordovaSettingForKey:@"CordovaDefaultWebViewEngine"];
    NSString* webViewEngineClass = [self.settings qh_cordovaSettingForKey:@"CordovaWebViewEngine"];

    if (!defaultWebViewEngineClass) {
        defaultWebViewEngineClass = @"QHUIWebViewEngine";//QHWKWebViewEngine//QHUIWebViewEngine
    }
    if (!webViewEngineClass) {
        webViewEngineClass = defaultWebViewEngineClass;
    }
    
    if ([QHLoanDoor share].coreWebViewEnum == QHCoreWebView_WKWebView) {
        webViewEngineClass = @"QHWKWebViewEngine";
    } else if ([QHLoanDoor share].coreWebViewEnum == QHCoreWebView_UIWebView) {
         webViewEngineClass = @"QHUIWebViewEngine";
    }
    
    // Find webViewEngine
    if (NSClassFromString(webViewEngineClass)) {
        self.webViewEngine = [[NSClassFromString(webViewEngineClass) alloc] initWithFrame:bounds];
        // if a webView engine returns nil (not supported by the current iOS version) or doesn't conform to the protocol, or can't load the request, we use UIWebView
        if (!self.webViewEngine || ![self.webViewEngine conformsToProtocol:@protocol(QHWebViewEngineProtocol)] || ![self.webViewEngine canLoadRequest:[NSURLRequest requestWithURL:self.appUrl]]) {
            self.webViewEngine = [[NSClassFromString(defaultWebViewEngineClass) alloc] initWithFrame:bounds];
        }
    } else {
        self.webViewEngine = [[NSClassFromString(defaultWebViewEngineClass) alloc] initWithFrame:bounds];
    }

    if ([self.webViewEngine isKindOfClass:[QHPlugin class]]) {
        [self registerPlugin:(QHPlugin*)self.webViewEngine withClassName:webViewEngineClass];
    }

    return self.webViewEngine.engineWebView;
}

- (NSString*)userAgent
{
    if (_userAgent != nil) {
        return _userAgent;
    }

    NSString* localBaseUserAgent;
    
   
    if ([self.settings qh_cordovaSettingForKey:@"OverrideUserAgent"] != nil) {
        localBaseUserAgent = [self.settings qh_cordovaSettingForKey:@"OverrideUserAgent"];
    } else {
        localBaseUserAgent = [QHUserAgentUtil originalUserAgent];
    }
    NSString* appendUserAgent = [self.settings qh_cordovaSettingForKey:@"AppendUserAgent"];
    if (appendUserAgent) {
        _userAgent = [NSString stringWithFormat:@"%@ %@", localBaseUserAgent, appendUserAgent];
    } else {
        // Use our address as a unique number to append to the User-Agent.
        _userAgent = [NSString stringWithFormat:@"%@ (%lld)", localBaseUserAgent, (long long)self];
    }
    
    if (self.baseUserAgent != nil) {
        if (![_userAgent containsString:self.baseUserAgent]) {
            _userAgent = [NSString stringWithFormat:@"%@ %@", _userAgent, self.baseUserAgent];
        }
    }
    
    return _userAgent;
}

- (void)createGapView
{
    CGRect webViewBounds = self.view.bounds;

    webViewBounds.origin = self.view.bounds.origin;

    UIView* view = [self newCordovaViewWithFrame:webViewBounds];

    view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:view];
    [self.view sendSubviewToBack:view];
}

- (void)acquireUserAgentTorequestForWebView
{
    NSURL* appURL = [self appUrl];
    
    [QHUserAgentUtil acquireLock:^(NSInteger lockToken) {
        _userAgentLockToken = lockToken;
        [QHUserAgentUtil setUserAgent:self.userAgent lockToken:lockToken];
        if (appURL) {
            //NSURLRequestUseProtocolCachePolicy
            NSURLRequest* appReq = [NSURLRequest requestWithURL:appURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
            [self.webViewEngine loadRequest:appReq];
        } else {
            NSString* loadErr = [NSString stringWithFormat:@"ERROR: Start Page at startPage Url'%@/%@' was not found.", self.wwwFolderName, self.startPage];
            NSLog(@"%@", loadErr);
            
            NSURL* errorUrl = [self errorURL];
            if (errorUrl) {
                errorUrl = [NSURL URLWithString:[NSString stringWithFormat:@"?error=%@", [loadErr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] relativeToURL:errorUrl];
                NSLog(@"%@", [errorUrl absoluteString]);
                [self.webViewEngine loadRequest:[NSURLRequest requestWithURL:errorUrl]];
            } else {
                NSString* html = [NSString stringWithFormat:@"<html><body> %@ </body></html>", loadErr];
                [self.webViewEngine loadHTMLString:html baseURL:nil];
            }
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    // iterate through all the plugin objects, and call hasPendingOperation
    // if at least one has a pending operation, we don't call [super didReceiveMemoryWarning]

    NSEnumerator* enumerator = [self.pluginObjects objectEnumerator];
    QHPlugin* plugin;

    BOOL doPurge = YES;

    while ((plugin = [enumerator nextObject])) {
        if (plugin.hasPendingOperation) {
            NSLog(@"Plugin '%@' has a pending operation, memory purge is delayed for didReceiveMemoryWarning.", NSStringFromClass([plugin class]));
            doPurge = NO;
        }
    }

    if (doPurge) {
        // Releases the view if it doesn't have a superview.
        [super didReceiveMemoryWarning];
    }

    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    [QHUserAgentUtil releaseLock:&_userAgentLockToken];

    [super viewDidUnload];
}

#pragma mark CordovaCommands

- (void)registerPlugin:(QHPlugin*)plugin withClassName:(NSString*)className
{
    if ([plugin respondsToSelector:@selector(setViewController:)]) {
        [plugin setViewController:self];
    }

    if ([plugin respondsToSelector:@selector(setCommandDelegate:)]) {
        [plugin setCommandDelegate:_commandDelegate];
    }

    [self.pluginObjects setObject:plugin forKey:className];
    [plugin pluginInitialize];
}

- (void)registerPlugin:(QHPlugin*)plugin withPluginName:(NSString*)pluginName
{
    if ([plugin respondsToSelector:@selector(setViewController:)]) {
        [plugin setViewController:self];
    }

    if ([plugin respondsToSelector:@selector(setCommandDelegate:)]) {
        [plugin setCommandDelegate:_commandDelegate];
    }

    NSString* className = NSStringFromClass([plugin class]);
    [self.pluginObjects setObject:plugin forKey:className];
    [self.pluginsMap setValue:className forKey:[pluginName lowercaseString]];
    [plugin pluginInitialize];
}

/**
 Returns an instance of a CordovaCommand object, based on its name.  If one exists already, it is returned.
 */
- (id)getCommandInstance:(NSString*)pluginName
{
    // first, we try to find the pluginName in the pluginsMap
    // (acts as a whitelist as well) if it does not exist, we return nil
    // NOTE: plugin names are matched as lowercase to avoid problems - however, a
    // possible issue is there can be duplicates possible if you had:
    // "org.apache.cordova.Foo" and "org.apache.cordova.foo" - only the lower-cased entry will match
    NSString* className = [self.pluginsMap objectForKey:[pluginName lowercaseString]];

    if (className == nil) {
        return nil;
    }

    id obj = [self.pluginObjects objectForKey:className];
    if (!obj) {
        obj = [[NSClassFromString(className)alloc] initWithWebViewEngine:_webViewEngine];

        if (obj != nil) {
            [self registerPlugin:obj withClassName:className];
        } else {
            NSLog(@"QHPlugin class %@ (pluginName: %@) does not exist.", className, pluginName);
        }
    }
    return obj;
}

#pragma mark -

- (NSString*)appURLScheme
{
    NSString* URLScheme = nil;

    NSArray* URLTypes = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];

    if (URLTypes != nil) {
        NSDictionary* dict = [URLTypes objectAtIndex:0];
        if (dict != nil) {
            NSArray* URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
            if (URLSchemes != nil) {
                URLScheme = [URLSchemes objectAtIndex:0];
            }
        }
    }

    return URLScheme;
}

#pragma mark -
#pragma mark UIApplicationDelegate impl

/*
 This method lets your application know that it is about to be terminated and purged from memory entirely
 */
- (void)onAppWillTerminate:(NSNotification*)notification
{
    // empty the tmp directory
    NSFileManager* fileMgr = [[NSFileManager alloc] init];
    NSError* __autoreleasing err = nil;

    // clear contents of NSTemporaryDirectory
    NSString* tempDirectoryPath = NSTemporaryDirectory();
    NSDirectoryEnumerator* directoryEnumerator = [fileMgr enumeratorAtPath:tempDirectoryPath];
    NSString* fileName = nil;
    BOOL result;

    while ((fileName = [directoryEnumerator nextObject])) {
        NSString* filePath = [tempDirectoryPath stringByAppendingPathComponent:fileName];
        result = [fileMgr removeItemAtPath:filePath error:&err];
        if (!result && err) {
            NSLog(@"Failed to delete: %@ (error: %@)", filePath, err);
        }
    }
}

/*
 This method is called to let your application know that it is about to move from the active to inactive state.
 You should use this method to pause ongoing tasks, disable timer, ...
 */
- (void)onAppWillResignActive:(NSNotification*)notification
{
    // NSLog(@"%@",@"applicationWillResignActive");
    [self.commandDelegate evalJs:@"cordova.fireDocumentEvent('resign');" scheduledOnRunLoop:NO];
}

/*
 In iOS 4.0 and later, this method is called as part of the transition from the background to the inactive state.
 You can use this method to undo many of the changes you made to your application upon entering the background.
 invariably followed by applicationDidBecomeActive
 */
- (void)onAppWillEnterForeground:(NSNotification*)notification
{
    // NSLog(@"%@",@"applicationWillEnterForeground");
    [self.commandDelegate evalJs:@"cordova.fireDocumentEvent('resume');"];

    /** Clipboard fix **/
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    NSString* string = pasteboard.string;
    if (string) {
        [pasteboard setValue:string forPasteboardType:@"public.text"];
    }
}

// This method is called to let your application know that it moved from the inactive to active state.
- (void)onAppDidBecomeActive:(NSNotification*)notification
{
    // NSLog(@"%@",@"applicationDidBecomeActive");
    [self.commandDelegate evalJs:@"cordova.fireDocumentEvent('active');"];
}

/*
 In iOS 4.0 and later, this method is called instead of the applicationWillTerminate: method
 when the user quits an application that supports background execution.
 */
- (void)onAppDidEnterBackground:(NSNotification*)notification
{
    // NSLog(@"%@",@"applicationDidEnterBackground");
    [self.commandDelegate evalJs:@"cordova.fireDocumentEvent('pause', null, true);" scheduledOnRunLoop:NO];
}

// ///////////////////////

- (void)dealloc
{
//     [[QHLoanDoor share] unRegisterQHLoanSDKURLProtocol];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [QHUserAgentUtil releaseLock:&_userAgentLockToken];
    [_commandQueue dispose];
    [[self.pluginObjects allValues] makeObjectsPerformSelector:@selector(dispose)];
}

- (NSInteger*)userAgentLockToken
{
    return &_userAgentLockToken;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [[QHLoanDoor share] unRegisterQHLoanSDKURLProtocol];
    [super dismissViewControllerAnimated:flag completion:completion];
}

- (void)rightBarBtnAction {
    switch ([QHLoanDoor share].coreWebViewEnum) {
        case QHCoreWebView_UIWebView:
            [(UIWebView *)self.webView stringByEvaluatingJavaScriptFromString:@"rightBarBtnAction()"];
            break;
        case QHCoreWebView_WKWebView:
            [(WKWebView *)self.webView evaluateJavaScript:@"rightBarBtnAction()" completionHandler:^(id object,NSError *error) {
                
            }];
            break;
        default:
            break;
    }
}

- (void)leftBarBtnAction
{
    
    switch ([QHLoanDoor share].coreWebViewEnum) {
        case QHCoreWebView_UIWebView:
            [self executeBackMethod:(UIWebView *)self.webView wkWebView:nil];
            break;
        case QHCoreWebView_WKWebView:
             [self executeBackMethod:nil wkWebView:(WKWebView *)self.webView];
            break;
        default:
            break;
    }
    
    
}

-(void) executeBackMethod:(UIWebView *) uiwebView wkWebView:(WKWebView *)wkwebView {
   
    if (self.nativeBackControl
        &&self.nativeBackControl.length > 0
        &&[self.nativeBackControl isEqualToString:@"webGoBack"]) {
        
        if (uiwebView) {
            [uiwebView stringByEvaluatingJavaScriptFromString:@"webGoBack()"];
        } else {
             [wkwebView evaluateJavaScript:@"webGoBack()" completionHandler:^(id object,NSError *error) {
                 
             }];
        }
        
        self.nativeBackControl = nil;
    } else if (self.nativeBackControl
               &&self.nativeBackControl.length > 0
               &&[self.nativeBackControl isEqualToString:@"nativeGoBack"]){
        [self.navigationController popViewControllerAnimated:YES];
         self.nativeBackControl = nil;
        
    } else if (self.nativeBackControl
               &&self.nativeBackControl.length > 0
               &&[self.nativeBackControl isEqualToString:@"nativeCloseAll"]){
        [self.navigationController popToRootViewControllerAnimated:YES];
         self.nativeBackControl = nil;
        
    } else {
        
        if (uiwebView) {
            if (uiwebView.canGoBack) {
                [uiwebView goBack];
            }else {
                [self goBackMethod];
            }
        } else {
            if (wkwebView.canGoBack) {
                [wkwebView goBack];
            }else {
                [self goBackMethod];
            }
        }
        
    }
}

- (void)goBackMethod {
    
    NSArray *vcArr = self.navigationController.viewControllers;
    if (vcArr.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.navigationController.presentingViewController)
        {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self.navigationController.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }
}
-(void)setBackBtnTitleColor:(NSString *) color backImg:(NSString *) img {
    
    if (color && color.length> 0) {
         [_backBtn setTitleColor:[UIColor qh_colorWithHexString:color] forState:UIControlStateNormal];
    }
    if (img && img.length > 0) {
        [_backBtn setImage:[UIImage imageNamed:img inBundle:[QHLoanDoorBundle bundle] compatibleWithTraitCollection:nil] forState: UIControlStateNormal];
    }

}
//必须在project中配置横竖屏选项
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

-(BOOL)prefersStatusBarHidden {
    [super prefersStatusBarHidden];
    
    return  self.navigationController.navigationBarHidden;
    
}
//transform当前页面角度来达到类似横竖屏
- (void)forceExecuteInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationPortrait || orientation ==UIInterfaceOrientationPortraitUpsideDown) {
        
      
        self.webView.transform = CGAffineTransformMakeRotation((0.0f * M_PI) / 180.0f);
        self.webView.frame = CGRectMake(0, 0, self.view.bounds.size.width,   self.view.bounds.size.height);
        //先转换再修改导航，否则会出现页面问题
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    } else {

        self.webView.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        self.webView.frame = CGRectMake(0, 0,  self.view.bounds.size.width,  self.view.bounds.size.height);
        [self.navigationController setNavigationBarHidden:YES animated:YES];

        
    }
}

//#pragma mark -QHBasicProtocol
////得到用户账户信息
//-(NSDictionary *)getAgentUserInfo {
//   
//}
////跳转new的h5Page
//-(BOOL)openNewPageWithUrl:(NSString *)url;
////打开调起登录
//-(void)openLaunchLoginPage;
////跳转new的Page params传递参数
//-(void)openNewPageWithParams:(NSDictionary *)params;
////得到H5信息操作 多功能接口 可以返回信息给H5
//-(NSDictionary *)executeH5InfoAction:(NSDictionary *)info;
//

@end
