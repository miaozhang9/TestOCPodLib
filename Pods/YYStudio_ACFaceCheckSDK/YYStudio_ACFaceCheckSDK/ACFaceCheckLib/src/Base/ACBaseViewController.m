//
//  BaseViewController.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/5/15.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseViewController.h"

#import "UIColor+Addtion.h"
#import "UIFont+Addtion.h"
#import "ACBaseNavigationController.h"
#import "ToastCenter.h"
#import "UIColor+Addtion.h"
#import "ACFaceCheckHelper.h"
#import <pthread.h>
#import "CredooApiFramework.h"
@interface ACBaseViewController ()

@property (nonatomic,strong) AFNetworkReachabilityManager *afmanager;

@property (nonatomic, strong) IPAInternetSpeedTest *speedTest;

@end

@implementation ACBaseViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginSuccess object:nil];
#ifdef DEBUG
    NSLog(@"====%@ dealloc====",NSStringFromClass(self.class));
#endif
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 登录成功的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kLoginSuccess object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor pc_colorWithHexString:@"#F5F5F5"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self resetBackBarButtonItem];

    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor pc_colorWithHexString:[ACFaceCheckHelper share].barTitleColor?[ACFaceCheckHelper share].barTitleColor:@"#4a4a4a"],NSFontAttributeName:[UIFont pingFangSCMediumWithSize:[ACFaceCheckHelper share].barTitleFontSize?[ACFaceCheckHelper share].barTitleFontSize:20]};
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = self.viewModel.title;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.afmanager) {
        [self.afmanager stopMonitoring];
    }
    if (_timer) {
        [self stopMeasure];
    }
}
#pragma mark - public

- (void)bindViewModel{
}

- (void)reloadData {
    
}

- (void)resetBackBarButtonItem {
    //暂时删除
    //    if (self.navigationController.viewControllers.count>1) {
    [self addLeftBarButtonItem];
    //    }
}

- (void)addLeftBarButtonItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[ACFaceCheckBundle imageNamed:@"nav_bar_back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarBtnAction)];
    self.navigationController.navigationBar.tintColor= [UIColor pc_colorWithHexString:[ACFaceCheckHelper share].tintColor?[ACFaceCheckHelper share].tintColor:@"#292C35"];
}

- (void)hideLeftBarButtonItem {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.hidesBackButton = YES;
}

// 移除navbar下边的黑线
- (void)removeNavBarBottomBlackLine {
    if ([self.navigationController isKindOfClass:[ACBaseNavigationController class]]) {
        ACBaseNavigationController *baseNavVc = (ACBaseNavigationController *)self.navigationController;
        [baseNavVc removeNavBarBottomBlackLine];
    }
}

// 修改navbar下边线条的颜色
- (void)changeNavBarBottomLineColor {
    if ([self.navigationController isKindOfClass:[ACBaseNavigationController class]]) {
        ACBaseNavigationController *baseNavVc = (ACBaseNavigationController *)self.navigationController;
        [baseNavVc changeNavBarBottomLineColor];
    }
}

- (void)showToast:(NSString *)toast{
    [[ToastCenter defaultCenter]postToastWithMessage:toast];
}

-(void)showLoading{
    
    if (pthread_main_np()) {
        if (!isloading) {
            NSLog(@"%@", self.navigationController.view);
            if (self.navigationController.view!=nil) {
                [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                isloading=YES;
            }
        }
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (!isloading) {
                NSLog(@"%@", self.navigationController.view);
                if (self.navigationController.view!=nil) {
                    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    isloading=YES;
                }
            }
        });
    }
}
- (void)hideLoading {
    
    if (pthread_main_np()) {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        isloading=NO;
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            isloading=NO;
        });
    }
    
}

- (void)showInternetSpeedView:(MeasureCompleteBlock)completeBlock {
//    [self.view addSubview:self.speedView];
    __weak typeof(self) weakSelf = self;
    self.speedTest = [[IPAInternetSpeedTest alloc] initWithblock:^(long speed) {
        NSString* speedStr = [NSString stringWithFormat:@"%@/s", [IPAInternetSpeedTools formattedFileSize:speed]];
        NSLog(@"即时速度:speed:%@",speedStr);
            [weakSelf updateShowSpeed:speed];
        
    } finishMeasureBlock:^(long speed) {
//        [weakSelf updateShowSpeed:speed];
//
//        NSString* speedStr = [NSString stringWithFormat:@"%@/s", [IPAInternetSpeedTools formattedFileSize:speed]];
//
//        NSLog(@"平均速度为：%@",speedStr);
//
//        NSLog(@"相当于带宽：%@",[IPAInternetSpeedTools formatBandWidth:speed]);
        if (completeBlock) {
            completeBlock();
        }
    } failedBlock:^(NSError *error) {
        
    }];
}

- (void)startMeasure {
    [self.speedTest startMeasur];
}

- (void)stopMeasure {
    self.speedTest = nil;
    [self.speedView removeFromSuperview];
    _speedView = nil;
    [self.timer invalidate];
    _timer = nil;
}

- (void)startAutoRefreshInternetSpeed {
    _timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(startMeasure) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)updateShowSpeed:(float )speed {
    if (speed < 1 * 1024) {
        self.speedLB.text = @"当前无网络连接，请检查网络。";
        self.speedLB.textColor = [UIColor pc_colorWithHexString:@"#F53420"];
//        self.speedView.backgroundColor = [UIColor pc_colorWithHexString:@"#FFE6E6"];
        self.speedView.backgroundColor = [UIColor clearColor];
    } else if (speed > 1 * 1024 && speed <= 250 * 1024) {
        self.speedLB.text = [NSString stringWithFormat:@"当前网络不稳定，网速%@",[NSString stringWithFormat:@"%@/s", [IPAInternetSpeedTools formattedFileSize:speed]]];
        self.speedLB.textColor = [UIColor pc_colorWithHexString:@"#F5A623"];
//        self.speedView.backgroundColor = [UIColor pc_colorWithHexString:@"#FEF5DE"];
        self.speedView.backgroundColor = [UIColor clearColor];
    } else {
        self.speedLB.text = [NSString stringWithFormat:@"当前网络质量：优，网速%@",[NSString stringWithFormat:@"%@/s", [IPAInternetSpeedTools formattedFileSize:speed]]];
        self.speedLB.textColor = [UIColor pc_colorWithHexString:@"#63A843"];
//        self.speedView.backgroundColor = [UIColor pc_colorWithHexString:@"#D1FCEF"];
        self.speedView.backgroundColor = [UIColor clearColor];
    }
}


#pragma mark - prative

- (void)leftBarBtnAction {
    if (self.navigationController.viewControllers.count <=1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - setter and getter

-(void)setViewModel:(ACBaseViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = viewModel;
        [self bindViewModel];
    }
}

- (UIView *)speedView {
    if (!_speedView) {
        self.speedView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, ACNScreenWidth, 30)];
//        _speedView.backgroundColor = [UIColor pc_colorWithHexString:@"#FFEFDB"];
        [_speedView addSubview:self.speedLB];
    }
    return _speedView;
}

- (UILabel *)speedLB {
    if (!_speedLB) {
        self.speedLB = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, ACNScreenWidth-40, 20)];
        self.speedLB.textAlignment = NSTextAlignmentLeft;
        _speedLB.font = [UIFont systemFontOfSize:12];
    }
    return _speedLB;
}


-(void)reachabilityStatusWithAFNetworkingWithToast:(BOOL)showToast WithBlock:(void(^)(BOOL isNet))result{
    self.afmanager = [AFNetworkReachabilityManager sharedManager];
    [self.afmanager startMonitoring];
    __weak typeof(self)weakSelf = self;
    [self.afmanager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                //未知网络
                if (showToast) {
                    [weakSelf showToast:@"未知网络"];
                }
                
                result(NO);
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                //无法联网
                if (showToast) {
                    [weakSelf showToast:@"无法联网,请检查网络"];
                }
                result(NO);
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                //手机自带网络
                if (showToast) {
                    [weakSelf showToast:@"当前使用的是2g/3g/4g网络"];
                }
                result(YES);
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                //WIFI
                if (showToast) {
                    [weakSelf showToast:@"当前在WIFI网络下"];
                }
                result(YES);
            }
                
        }
    }];
    
}
- (void)goBackViewControllerWithIsRoot:(BOOL)isRoot {
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        NSArray *viewcontrollers = self.navigationController.viewControllers;
        if (viewcontrollers.count>1) {
            if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
                if (isRoot) {
                    
                    [self popToRootViewController];
                    
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }
        }
        else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
}
- (void)popToRootViewController {
    
    if ([ACFaceCheckHelper share].getHostFromeVC) {
        NSArray *viewcontrollers = self.navigationController.viewControllers;
        if ([viewcontrollers containsObject:[ACFaceCheckHelper share].getHostFromeVC]) {
             [self.navigationController popToViewController:[ACFaceCheckHelper share].getHostFromeVC animated:YES];
        } else {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
