//
//  ACFaceCheckHelper.m
//  ACFaceCheckLib
//
//  Created by Miaoz on 2017/11/22.
//  Copyright © 2017年 Miaoz. All rights reserved.
//

#import "ACFaceCheckHelper.h"
#import "ACBaseViewController.h"
#import "ACAppointmentMainViewController.h"
#import "PCUserLevelService.h"
#import "CredooApiFramework.h"
#import "PCLoginAndRegistViewModel.h"
#import "PCLoginConfirmViewModel.h"
#import "ACBaseNavigationController.h"
#import "ACEnviromentGlobal.h"
#import "UIFont+Addtion.h"
#import "ACNNewInterviewViewController.h"
#import "ACAppointSelectorViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ACAlertManager.h"
@interface  ACFaceCheckHelper ()


@property (nonatomic, strong) ACBaseViewController *viewController;
@property(nonatomic, strong)PCUserLevelService *userLevelService;
@property(nonatomic, strong)PCLoginAndRegistViewModel *loginAndRegistViewModel;
@property(nonatomic, strong)PCLoginConfirmViewModel *loginConfirmViewModel;

@property(nonatomic,strong)ACMyLastAppointDTO *lastAppointDTO;
@property(nonatomic,strong)UIViewController *hostFromeVC;

@end
@implementation ACFaceCheckHelper


static ACFaceCheckHelper *helper;

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
- (ACFaceCheckConfigToDic)setDataInfo
{
    __weak typeof(self) weakSelf = self;
    return ^(NSDictionary *dataDic){
        
        self.dataInfo = dataDic;
        return weakSelf;
    };
}

- (ACFaceCheckConfigToString)setBarColor{
    
    __weak typeof(self) weakSelf = self;
    return ^(NSString *str){
        
        self.barColor = str;
        return weakSelf;
    };
    
}

- (ACFaceCheckConfigToString)setBarTitleColor
{
    __weak typeof(self) weakSelf = self;
    return ^(NSString *str){
        
        self.barTitleColor = str;
        return weakSelf;
    };
}

- (ACFaceCheckConfigToInteger)setBarTitleFontSize
{
    
    __weak typeof(self) weakSelf = self;
    return ^(NSInteger integer){
        
        self.barTitleFontSize = integer;
        return weakSelf;
    };
}

- (ACFaceCheckConfigToString)setTintColor {
    
    __weak typeof(self) weakSelf = self;
    return ^(NSString *str){
        
        self.tintColor = str;
        return weakSelf;
    };
    
}

- (ACFaceCheckConfigToString)setUserPhone {
    
    __weak typeof(self) weakSelf = self;
    return ^(NSString *str){
        self.userPhone = str;
        
        return weakSelf;
    };
    
}
- (ACFaceCheckConfigToString)setUserPassWord {
    __weak typeof(self) weakSelf = self;
    return ^(NSString *str){
        self.userPassWord = str;
        
        return weakSelf;
    };
}
- (ACFaceCheckConfigToString)setUserName {
    __weak typeof(self) weakSelf = self;
    return ^(NSString *str){
        self.userName = str;
        
        return weakSelf;
    };
}
- (ACFaceCheckConfigToString)setReloginKey {
    __weak typeof(self) weakSelf = self;
    return ^(NSString *str){
        self.reloginKey = str;
        
        return weakSelf;
    };
}
- (ACFaceCheckConfigToEnvironment)setEnvironment {
    
    __weak typeof(self) weakSelf = self;
    return ^(ACFaceCheckEnvironment environment){
        self.environment = environment;
        [[CredooApiFramework sharedInstance] setHttpBaseUrl:@[kHttpURL] withSignPrefix:kHttpSignPrefix withHttpSignSurfix:kHttpSignSurfix];
        return weakSelf;
    };
}

-(ACFaceCheckConfig)start
{
    
    
    __weak typeof(self) weakSelf = self;
    return ^(void){
        
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        if (!window) {
            NSError *error = [NSError errorWithDomain:@"no key window" code:0 userInfo:@{}];
            if (_callBackBlcok) {
                self.callBackBlcok(NO, error);
            }
            return self;
        }
        UIViewController *rootCtrl = window.rootViewController;
        if (!rootCtrl) {
            NSError *error = [NSError errorWithDomain:@"no key window" code:0 userInfo:@{}];
            if (_callBackBlcok) {
                self.callBackBlcok(NO, error);
            }
            return self;
        }
        
        if (self.dataInfo) {
            [self excutingStartWithData:self.dataInfo];
        } else {
            [self loginConfirmIsData:YES];
//            [self loginConfirm];
        }
        
        return weakSelf;
    };
    
}

-(ACFaceCheckConfig)login
{
    __weak typeof(self) weakSelf = self;
    return ^(void){
        
//        UIWindow *window = [[UIApplication sharedApplication].delegate window];
//        if (!window) {
//            NSError *error = [NSError errorWithDomain:@"no key window" code:0 userInfo:@{}];
//            if (_callBackBlcok) {
//                self.callBackBlcok(NO, error);
//            }
//            return self;
//        }
//        UIViewController *rootCtrl = window.rootViewController;
//        if (!rootCtrl) {
//            NSError *error = [NSError errorWithDomain:@"no key window" code:0 userInfo:@{}];
//            if (_callBackBlcok) {
//                self.callBackBlcok(NO, error);
//            }
//            return self;
//        }
       
        [self loginConfirmIsData:NO];
    
        return weakSelf;
    };
    
}



//
//- (ACFaceCheckHelper *(^)(NSDictionary *))setDataInfo
//{
//    ACFaceCheckHelper * (^callBlock)(NSDictionary *) = ^(NSDictionary *dataDic) {
//        self.dataInfo = dataDic;
//
//        return self;
//    };
//    return callBlock;
//}
//
//
//- (ACFaceCheckHelper *(^)(NSString *))setBarColor
//{
//    ACFaceCheckHelper * (^callBlock)(NSString *) = ^(NSString *barColor) {
//        self.barColor = barColor;
//        return self;
//    };
//    return callBlock;
//}
//
//- (ACFaceCheckHelper *(^)(NSString *))setBarTitleColor
//{
//    ACFaceCheckHelper * (^callBlock)(NSString *) = ^(NSString *barTitleColor) {
//        self.barTitleColor = barTitleColor;
//        return self;
//    };
//    return callBlock;
//}
//
//- (ACFaceCheckHelper *(^)(NSInteger ))setBarTitleFontSize
//{
//    ACFaceCheckHelper * (^callBlock)(NSInteger) = ^(NSInteger barTitleFontSize) {
//        self.barTitleFontSize = barTitleFontSize;
//        return self;
//    };
//    return callBlock;
//}
//
//- (ACFaceCheckHelper *(^)(NSString *))setTintColor {
//    ACFaceCheckHelper * (^callBlock)(NSString *) = ^(NSString *tintColor) {
//        self.tintColor = tintColor;
//        return self;
//    };
//    return callBlock;
//}
//
//- (ACFaceCheckHelper *(^)(NSString *))setUserPhone {
//    ACFaceCheckHelper * (^callBlock)(NSString *) = ^(NSString *userPhone) {
//        self.userPhone = userPhone;
//        return self;
//    };
//    return callBlock;
//}
//- (ACFaceCheckHelper *(^)(NSString *))setUserPassWord {
//    ACFaceCheckHelper * (^callBlock)(NSString *) = ^(NSString *userPassWord) {
//        self.userPassWord = userPassWord;
//        return self;
//    };
//    return callBlock;
//}
//- (ACFaceCheckHelper *(^)(NSString *))setUserName {
//    ACFaceCheckHelper * (^callBlock)(NSString *) = ^(NSString *userName) {
//        self.userName = userName;
//        return self;
//    };
//    return callBlock;
//}
//
//- (ACFaceCheckHelper *(^)(ACFaceCheckEnvironment cc))setEnvironment {
//    ACFaceCheckHelper * (^callBlock)(ACFaceCheckEnvironment cc) = ^(ACFaceCheckEnvironment environment) {
//        self.environment = environment;
////        [self changeEnvironment];
//        [[CredooApiFramework sharedInstance] setHttpBaseUrl:@[kHttpURL] withSignPrefix:kHttpSignPrefix withHttpSignSurfix:kHttpSignSurfix];
//        return self;
//    };
//    return callBlock;
//}
//
//
//-(ACFaceCheckHelper *(^)(void))start
//{
//    ACFaceCheckHelper * (^callBlock)(void) = ^() {
//
//        UIWindow *window = [[UIApplication sharedApplication].delegate window];
//        if (!window) {
//            NSError *error = [NSError errorWithDomain:@"no key window" code:0 userInfo:@{}];
//            if (_callBackBlcok) {
//                self.callBackBlcok(NO, error);
//            }
//            return self;
//        }
//        UIViewController *rootCtrl = window.rootViewController;
//        if (!rootCtrl) {
//            NSError *error = [NSError errorWithDomain:@"no key window" code:0 userInfo:@{}];
//            if (_callBackBlcok) {
//                self.callBackBlcok(NO, error);
//            }
//            return self;
//        }
//
//        if (self.dataInfo) {
//             [self excutingStartWithData:self.dataInfo];
//        } else {
//            [self getCaptcha];
//        }
//
//
//
//
//        return self;
//    };
//
//    return callBlock;
//}

- (void)changeEnvironment{
    NSString *enviromentPath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"enviroment.plist"] ;
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:enviromentPath];
    //修改字典里面的内容,先按照结构取到你想修改内容的小字典
    NSLog(@"---plist做过操作之后的字典里面内容---%@",dataDictionary);

    switch (self.environment) {
        case ACFaceCheckEnvironment_stg:
            [dataDictionary setObject:@"Stage" forKey:@"Environment"];
            break;
        case ACFaceCheckEnvironment_prd:
            [dataDictionary setObject:@"Prod" forKey:@"Environment"];
            break;
        case ACFaceCheckEnvironment_dev:
            [dataDictionary setObject:@"Development" forKey:@"Environment"];
            break;
        default:
            [dataDictionary setObject:@"Stage" forKey:@"Environment"];
            break;
    }
}

//- (void)getCaptcha{
//
//     PCLoginAndRegistViewModel *viewModel = [[PCLoginAndRegistViewModel alloc]init];
//    self.loginAndRegistViewModel = viewModel;
//    viewModel.phoneNum = self.userPhone? self.userPhone:@"18870630008";
//    viewModel.verifyCode = @"1";
//    viewModel.imgType = @"1";
//    __weak typeof(self)weakSelf = self;
//    [viewModel getImgCaptchaSignalsuccess:^(id data) {
//         [weakSelf getUserLevel];
//    } failed:^(NSError *error) {
//
//    }];
//
//}
//
//- (void)getUserLevel {
//
//     __weak typeof(self)weakSelf = self;
//    [self.loginAndRegistViewModel getUserLevelRequesSignalsuccess:^(id responseDTO) {
//        [weakSelf loginConfirmIsData:YES];
//    } failed:^(NSError *error) {
//
//    }];
//}

-(void)loginConfirmIsData:(BOOL) isData {

    self.loginConfirmViewModel = [[PCLoginConfirmViewModel alloc]init];
//    self.loginConfirmViewModel.phone = self.loginAndRegistViewModel.phoneNum;
    self.loginConfirmViewModel.phone = self.userPhone? self.userPhone:@"18870630008";
    self.loginConfirmViewModel.password = self.userPassWord?self.userPassWord:@"qweqwe123";
     __weak typeof(self)weakSelf = self;
    [self.loginConfirmViewModel requestPasswordLoginSignalsuccess:^(id responseDTO) {
        if (isData) {
             [weakSelf excutingMockDataStart];
        } else {
            if (_callBackBlcok) {
                self.callBackBlcok(true, nil);
            }
        }
        
    } failed:^(NSError *error) {

    }];

}

- (void) excutingMockDataStart {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *rootCtrl = window.rootViewController;
    ACAppointmentMainViewController *viewController = [[ACAppointmentMainViewController alloc]init];
    self.viewController = viewController;
    viewController.dic = @{@"date":@"2017-11-02 03:18:17",
                           @"description":@"36个月",
                           @"disabled":@"0",
                           @"evtclick":@"跳转面签页面",
                           @"orderId":@"ylb2017110203123698052913",
                           @"ordertype":@"富一贷",
                           @"status":@"待面核",
                           @"statuscode":@"211",
                           @"sum":@"150,000" };
    //
    //                viewController.navigationController.navigationBar.translucent = NO;
    //                  [self.navigationController pushViewController:vc animated:YES];
    ACBaseNavigationController *nav = [[ACBaseNavigationController alloc]initWithRootViewController:viewController];
    //[[UINavigationController alloc] initWithRootViewController:viewController]
    [rootCtrl presentViewController:nav animated:YES completion:^{
        if (_callBackBlcok) {
            self.callBackBlcok(YES, nil);
        }


    }];
// self.viewController.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor colorWithHexString:self.barTitleColor?self.barTitleColor:@"#000000"],NSFontAttributeName:[UIFont pingFangSCMediumWithSize:self.barTitleFontSize?self.barTitleFontSize:20]};
//    [self.viewController.navigationController.navigationBar setBackgroundColor:[UIColor colorWithHexString:self.barColor?self.barColor:@"#FFFFFF"]];
//    self.viewController.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:self.barColor?self.barColor:@"#FFFFFF"];


}


- (void) excutingStartWithData:(NSDictionary *)dic {
    __weak typeof(self)weakSelf = self;
    [self checkCameraAuthority:^(bool cameraisopen) {
        if (cameraisopen) {
            [weakSelf checkMicrophoneAuthority:^(bool microphoneisopen) {
                if (microphoneisopen) {
                    UIWindow *window = [[UIApplication sharedApplication].delegate window];
                    UIViewController *rootCtrl = window.rootViewController;
                    ACAppointmentMainViewController *viewController = [[ACAppointmentMainViewController alloc]init];
                    weakSelf.viewController = viewController;
                    viewController.dic = dic;
                    ACBaseNavigationController *nav = [[ACBaseNavigationController alloc]initWithRootViewController:viewController];
                    [rootCtrl presentViewController:nav animated:YES completion:^{
                        if (_callBackBlcok) {
                            weakSelf.callBackBlcok(YES, nil);
                        }
                        
                    }];

                }
            }];
        }
    }];
   

}

-(void)setYjkProductInfo:(NSString *)yjkProductInfo{
    _yjkProductInfo = yjkProductInfo;
    [[NSUserDefaults standardUserDefaults]setObject:yjkProductInfo forKey:@"anychatHelpUrl"];
}
#pragma mark appointState
-(void)orderWithAppointStateWithOrderInfo:(NSDictionary *)orderDic success:(void (^)(ACFaceCheckOrderAppointState orderAppointState, id acMyLastAppointDTO, NSDictionary *otherInfo))success failed:(void (^)(NSError *error))failed {
    ACAppointmentViewModel *appointViewModel = [[ACAppointmentViewModel alloc] init];
    NSString *phone = [ACFaceCheckHelper share].userPhone;
    __weak typeof(self)weakSelf = self;
    [appointViewModel myLasteAppointRequestSignalWithPhone:phone success:^(id responseDTO) {
        ACMyLastAppointDTO *appointDTO = (ACMyLastAppointDTO *)responseDTO;
        weakSelf.lastAppointDTO = appointDTO;
        //排队中
        if ([appointDTO.isqueuing isEqualToString:@"1"]) {//显示排队界面
            self.orderAppointState = ACFaceCheckOrderAppointState_isqueuing;
            success(ACFaceCheckOrderAppointState_isqueuing, appointDTO, orderDic);
            
        }else {
            
            if([appointDTO.queuingInother isEqualToString:@"1"]){//只显示发起面签button 已经在其他队列中
                 self.orderAppointState = ACFaceCheckOrderAppointState_queuingInother;
                success(ACFaceCheckOrderAppointState_queuingInother, appointDTO, orderDic);
                
            } else if([appointDTO.queueavailable isEqualToString:@"1"]){//只显示发起面签button
                
                  self.orderAppointState = ACFaceCheckOrderAppointState_vailableInterview;
                success(ACFaceCheckOrderAppointState_vailableInterview, appointDTO, orderDic);
                
            }else if([appointDTO.appointcreate isEqualToString:@"1"]){//只显示预约面签button
                
                if ([appointDTO.isPassToday isEqualToString:@"1"]) {//放鸽子
                      self.orderAppointState = ACFaceCheckOrderAppointState_overdueappoint;
                    success(ACFaceCheckOrderAppointState_overdueappoint, appointDTO, orderDic);
                }else{
                      self.orderAppointState = ACFaceCheckOrderAppointState_appointInterview;
                    success(ACFaceCheckOrderAppointState_appointInterview, appointDTO, orderDic);
                }
                
            }else if([appointDTO.appointupdate isEqualToString:@"1"]){//显示取消预约、申请改期button，发起面签button置灰
                  self.orderAppointState = ACFaceCheckOrderAppointState_appointupdate;
                success(ACFaceCheckOrderAppointState_appointupdate, appointDTO, orderDic);
                
            }else{//置灰预约面签 其他不显示
                  self.orderAppointState = ACFaceCheckOrderAppointState_appointDefault;
                success(ACFaceCheckOrderAppointState_appointDefault, appointDTO, orderDic);
                
            }
            
        }
        
    } failed:^(NSError *error) {
        
        failed(error);
        
    }];
}


-(void)enterQueueVCWithFromVC:(UIViewController *)vc inputType:(ACFaceCheckInputType)type{
    __weak typeof(self)weakSelf = self;
    [self checkCameraAuthority:^(bool cameraisopen) {
        if (cameraisopen) {
            [weakSelf checkMicrophoneAuthority:^(bool microphoneisopen) {
                if (microphoneisopen) {
                    weakSelf.hostFromeVC = vc;
                    ACNNewInterviewViewController * interviewVC = [[ACNNewInterviewViewController alloc]init];
                    interviewVC.lastAppointDTO = weakSelf.lastAppointDTO;
                    if (type == ACFaceCheckInputType_push) {
                        [vc.navigationController pushViewController:interviewVC animated:YES];
                    }else if(type == ACFaceCheckInputType_present){
                        ACBaseNavigationController *nav = [[ACBaseNavigationController alloc]initWithRootViewController:interviewVC];
                        [vc presentViewController:nav animated:YES completion:nil];
                    }
                }
            }];
        }
    }];
    
}

- (void)enterAppointSelectorVCWithFromVC:(UIViewController *)vc inputType:(ACFaceCheckInputType)type ACFaceCheckOrderAppointState:(ACFaceCheckOrderAppointState)orderAppointState orderInfo:(NSDictionary *)orderDic {
    self.hostFromeVC = vc;
    ACAppointSelectorViewController *appointSelectorVC = [[ACAppointSelectorViewController alloc] init];
    appointSelectorVC.lastAppointDTO = self.lastAppointDTO;
    appointSelectorVC.dic = orderDic;
    appointSelectorVC.orderAppointState = orderAppointState;
    if (type == ACFaceCheckInputType_push) {
        [vc.navigationController pushViewController:appointSelectorVC animated:YES];
    }else if(type == ACFaceCheckInputType_present){
         ACBaseNavigationController *nav = [[ACBaseNavigationController alloc]initWithRootViewController:appointSelectorVC];
        [vc presentViewController:nav animated:YES completion:nil];
    }
    
}

-(void)leaveQueuesuccess:(void (^)(id))success failed:(void (^)(NSError *))failed{
    ACAppointmentViewModel *appointViewModel = [[ACAppointmentViewModel alloc] init];
    NSString *phone = [ACFaceCheckHelper share].userPhone;
    [appointViewModel leaveQueueleaveQueueWithphone:phone success:^(id responseDTO) {
        success(responseDTO);
    } failed:^(NSError *error) {
        failed(error);
    }];
}

- (UIViewController *)getHostFromeVC {
    
    return self.hostFromeVC;
}
#pragma mark 权限
- (void)checkCameraAuthority:(void(^)(bool))callback {
    //获得App相机目前权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //判断设备是否支持相机
        [self alertIsCamera];
        //        [self alertAuthority];
        callback(NO);
    } else if (AVAuthorizationStatusAuthorized == authStatus) {
        //已授权设备使用相机
        callback(YES);
    } else if (AVAuthorizationStatusNotDetermined == authStatus) {
        //用户尚未做出任何授权操作
        //为App申请相机访问权限
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            callback(granted);
        }];
    } else {
        // 用户拒绝授权或者家长限制
        [self alertAuthority];
        callback(NO);
    }
}
- (void)checkMicrophoneAuthority:(void(^)(bool))callback{
    AVAudioSession* sharedSession = [AVAudioSession sharedInstance];
    AVAudioSessionRecordPermission permission = [sharedSession recordPermission];
    if (permission == AVAudioSessionRecordPermissionUndetermined) {
        // 还未决定，说明系统权限请求框还未弹出
        AVAudioSession* sharedSession = [AVAudioSession sharedInstance];
        [sharedSession requestRecordPermission:^(BOOL granted) {
            callback(granted);
        }];
    } else if (permission == AVAudioSessionRecordPermissionDenied) {
        // 用户明确拒绝，不再弹出系统权限请求框
        [self alertMicrophoneAuthority];
        callback(NO);
    } else if (permission == AVAudioSessionRecordPermissionGranted) {
        // 用户明确授权
        callback(YES);
    }
}
- (void)alertIsCamera {
    ACAlertManager *alertManager = [ACAlertManager shareAlertManager];
    [alertManager showAlertMessageWithTitle:@"温馨提示" content:@"手机前置摄像头故障，无法正常调用该功能，请确认后使用！" okeyTitle:@"确定" okeyAction:^{
        
    } cancelTitle:nil cancelAction:nil];
}
- (void)alertAuthority {
    //面核需要您打开“相机”，请设置为允许
    ACAlertManager *alertManager = [ACAlertManager shareAlertManager];
    [alertManager showAlertMessageWithTitle:@"温馨提示" content:@"需要您打开相机权限”，请设置为允许" okeyTitle:@"去设置" okeyAction:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    } cancelTitle:nil cancelAction:nil];
}
- (void)alertMicrophoneAuthority {
    //面核需要您打开“麦克风权限”，请设置为允许
    ACAlertManager *alertManager = [ACAlertManager shareAlertManager];
    [alertManager showAlertMessageWithTitle:@"温馨提示" content:@"需要您打开麦克风权限”，请设置为允许" okeyTitle:@"去设置" okeyAction:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    } cancelTitle:nil cancelAction:nil];
}
@end
/**
 ////设置传递信息
 //- (ACFaceCheckHelper *(^)(NSDictionary *))setDataInfo;
 ////设置环境
 //- (ACFaceCheckHelper *(^)(ACFaceCheckEnvironment ))setEnvironment;
 //
 ////设置导航条颜色
 //- (ACFaceCheckHelper *(^)(NSString *))setBarColor;
 ////设置title颜色
 //- (ACFaceCheckHelper *(^)(NSString *))setBarTitleColor;
 ////设置title字体大小
 //- (ACFaceCheckHelper *(^)(NSInteger ))setBarTitleFontSize;
 ////设置返回颜色
 //- (ACFaceCheckHelper *(^)(NSString *))setTintColor;
 ////用户电话
 //- (ACFaceCheckHelper *(^)(NSString *))setUserPhone;
 ////可选
 //- (ACFaceCheckHelper *(^)(NSString *))setUserPassWord;
 //
 ////用户名字
 //- (ACFaceCheckHelper *(^)(NSString *))setUserName;
 ////启动SDK
 //- (ACFaceCheckHelper *(^)(void))start;
 //- (void)getCaptcha;
 //- (void)getUserLevel;
 //- (void)loginConfirm;
 //- (void) excutingMockDataStart ;
 //- (void) excutingStartWithData:(NSDictionary *)dic ;

 **/
