//
//  ViewController.m
//  TestOCPodLib
//
//  Created by Miaoz on 2018/5/11.
//  Copyright © 2018年 Miaoz. All rights reserved.
//

#import "ViewController.h"
//#import <OCFTFaceDetect/OCFTFaceDetector.h>
//#import <YYStudio_LoanSDK_All/OCFTFaceDetector.h>
#import <YYStudio_LoanSDK_All/QHLoanDoor.h>
//#import <YYStudio_LoanSDK/YYStudio_LoanSDK.h>
//#import <YYStudio_ACFaceCheckSDK/YYStudio_ACFaceCheckSDK.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [OCFTFaceDetector getSDKInfo];
     Class pacteraClass = NSClassFromString(@"oneViewController");
     NSString *str = @"www/index.html";
      [QHLoanDoor share].setDataInfo(@{}).setBasicDelegate(self).setBarColor(@"#d8e6ff").setBarTitleColor(@"#000000").setBarTitleFontSize(17).setBackBtnTitle(@"返回").setBackBtnTitleColor(@"#ff6600").setBackBtnImage(nil).setAgent(@"Agent").setCoreWebView(QHCoreWebView_UIWebView).setStartPageUrl(str).setJumpTypeEnum(QHLoanDoorJumpType_present).start();
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
