//
//  BaseViewController.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/5/15.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ACBaseViewModel.h"

#import "MBProgressHUD.h"
#import "UIColor+Addtion.h"
#import "ACAppConstant.h"
#import <Masonry/Masonry.h>
#import "IPAInternetSpeedTest.h"
#import "IPAInternetSpeedTools.h"
#import "ACFaceCheckBundle.h"
typedef void(^MeasureCompleteBlock)(void);

@interface ACBaseViewController : UIViewController
{
    BOOL isloading;
}
@property (nonatomic, strong) ACBaseViewModel *viewModel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *speedView;
@property (nonatomic, strong) UILabel *speedLB;

- (void)reloadData;
- (void)bindViewModel;

// 移除navbar下边的黑线
- (void)removeNavBarBottomBlackLine;
// 修改navbar下边线条的颜色
- (void)changeNavBarBottomLineColor;


- (void)showToast:(NSString *)toast;

-(void)showLoading;

-(void)hideLoading;

- (void)addLeftBarButtonItem;
- (void)leftBarBtnAction;

- (void)hideLeftBarButtonItem;

-(void)reachabilityStatusWithAFNetworkingWithToast:(BOOL)showToast WithBlock:(void(^)(BOOL isNet))result;

- (void)showInternetSpeedView:(MeasureCompleteBlock)completeBlock;

- (void)startMeasure;

- (void)stopMeasure;

- (void)startAutoRefreshInternetSpeed;

- (void)goBackViewControllerWithIsRoot:(BOOL)isRoot;

- (void)popToRootViewController ;


@end
