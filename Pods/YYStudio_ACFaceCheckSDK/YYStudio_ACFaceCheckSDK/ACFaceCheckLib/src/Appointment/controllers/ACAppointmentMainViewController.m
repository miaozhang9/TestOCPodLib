//
//  PCAppointmentMainViewController.m
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/21.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACAppointmentMainViewController.h"
#import "ACAppointmentViewModel.h"
#import "ACMyLastAppointDTO.h"
#import "ACAppointmentViewController.h"
#import "ACNNewInterviewViewController.h"
#import "ACAlertManager.h"
#import "UIView+Addtion.h"
#import "AnyChatWebViewController.h"
#import "UIFont+Addtion.h"
#import "ACFaceCheckHelper.h"
@interface ACAppointmentMainViewController ()

@property(nonatomic,strong)ACAppointmentViewController *appointVC;
@property(nonatomic,strong)ACNNewInterviewViewController *acnVC;
@property(nonatomic,strong)ACAppointmentViewModel *appointViewModel;

@property (nonatomic, assign) BOOL isEnd;
@property (nonatomic, assign) BOOL isHelp;

@end

@implementation ACAppointmentMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self removeViewAndController];
    [self reachabilityStatusMonitoring];
//    [self addRightBarButton];
    _isEnd = NO;
    _isHelp = NO;
    [self getLastAppointmentWithPhone:[ACFaceCheckHelper share].userPhone];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.acnVC) {
        self.title = @"新面核系统";
        self.navigationItem.title = @"新面核系统";
    } else {
        self.title = @"订单详情";
        self.navigationItem.title = @"订单详情";
    }
    if (_isHelp) {
        [self getLastAppointmentWithPhone:[ACFaceCheckHelper share].userPhone];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _isEnd = YES;
    _isHelp = NO;
     [NSObject cancelPreviousPerformRequestsWithTarget:self];
 
}


- (void)dealloc
{
        [self removeViewAndController];
}
- (void)addRightBarButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[ACFaceCheckBundle imageNamed:@"consult_anyloan"] style:UIBarButtonItemStylePlain target:self action:@selector(enterConsultAnyloan)];
}

- (void)addStopQueueRightBarButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"放弃面核" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnStopQueueAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor pc_colorWithHexString:Color2264F4]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont pingFangSCRegularWithSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont pingFangSCRegularWithSize:14],NSFontAttributeName, nil] forState:UIControlStateHighlighted];
//    self.navigationController.navigationBar.tintColor= [UIColor pc_colorWithHexString:@"#2363FF"];

}

- (void)enterConsultAnyloan {
    _isHelp = YES;
    AnyChatWebViewController *vc = [AnyChatWebViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightBarBtnStopQueueAction {
    [self.acnVC rightBarBtnAction];
}
- (void)pollAfterGetLastAppointmentRequest {
    if (!_isEnd ) {
         [self performSelector:@selector(getLastAppointmentData) withObject:nil afterDelay:30];
    }
   
//    if (!_isEnd) {
    
//          @weakify(self)
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            @strongify(self)
//           if (!_isEnd) {
//            [self getLastAppointmentWithOrderId:[self.dic valueForKey:@"orderId"]];
//           }
//        });
//    }
}
- (void)getLastAppointmentData {

  [self getLastAppointmentWithPhone:[ACFaceCheckHelper share].userPhone];
 
}

- (void)refreshUI{
    [self reloadData];
}

- (void)removeViewAndController {
    //清空视图刷新状态
    if (self.acnVC) {
        [self.acnVC willMoveToParentViewController:nil];
        [self.acnVC.view removeFromSuperview];
        [self.acnVC removeFromParentViewController];
        self.acnVC = nil;
    }
    
    if (self.appointVC) {
        [self.appointVC willMoveToParentViewController:nil];
        [self.appointVC.view removeFromSuperview];
        [self.appointVC removeFromParentViewController];
        self.appointVC = nil;
    }
}

- (void)reloadData {
    //暂时注释
    //[self getLastAppointmentWithPhone:[ACFaceCheckHelper share].userPhone]];
}

-(void)getLastAppointmentWithPhone:(NSString *)phone{
    __weak typeof(self) weakSelf = self;

    [self.appointViewModel myLasteAppointRequestSignalWithPhone:phone success:^(id responseDTO) {
        ACMyLastAppointDTO *x = (ACMyLastAppointDTO *)responseDTO;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf removeViewAndController];
        //排队中
        if ([x.isqueuing isEqualToString:@"1"]) {//显示排队界面
            if (!strongSelf.acnVC) {
                [strongSelf addStopQueueRightBarButton];
                strongSelf.acnVC = [[ACNNewInterviewViewController alloc]init];
                strongSelf.acnVC.lastAppointDTO = x;
                strongSelf.acnVC.appointmentMainVC = strongSelf;
                [strongSelf addChildViewController:strongSelf.acnVC];
                [strongSelf.view addSubview:strongSelf.acnVC.view];
                [strongSelf.acnVC didMoveToParentViewController:strongSelf];
                strongSelf.title = @"新面核系统";
            } else {
                strongSelf.acnVC.lastAppointDTO = x;
                //预约过期刷新订单详情状态
                strongSelf.acnVC.refreshBlock = ^{
                    [weakSelf getLastAppointmentWithPhone:[ACFaceCheckHelper share].userPhone];
                };
            }

            
        }else {
            if (!strongSelf.appointVC) {
                strongSelf.title = @"订单详情";
                [strongSelf addRightBarButton];
                strongSelf.appointVC = [[ACAppointmentViewController alloc]init];
                strongSelf.appointVC.lastAppointDTO = x;
                strongSelf.appointVC.dic = strongSelf.dic;
                [strongSelf.view addSubview:strongSelf.appointVC.view];
                [strongSelf addChildViewController:strongSelf.appointVC];
            } else {
                strongSelf.appointVC.lastAppointDTO = x;
            }
            
            
            if([x.queuingInother isEqualToString:@"1"]){//在其他队列中 
                [strongSelf.appointViewModel leaveQueueleaveQueueWithphone:phone success:^(id data) {
                    if (!weakSelf.acnVC) {
                        [weakSelf addStopQueueRightBarButton];
                        weakSelf.acnVC = [[ACNNewInterviewViewController alloc]init];
                        weakSelf.acnVC.lastAppointDTO = x;
                        weakSelf.acnVC.appointmentMainVC = weakSelf;
                        [weakSelf addChildViewController:weakSelf.acnVC];
                        [weakSelf.view addSubview:strongSelf.acnVC.view];
                        [weakSelf.acnVC didMoveToParentViewController:weakSelf];
                        weakSelf.title = @"新面核系统";
                    } else {
                        weakSelf.acnVC.lastAppointDTO = x;
                        //预约过期刷新订单详情状态
                        weakSelf.acnVC.refreshBlock = ^{
                            [weakSelf getLastAppointmentWithPhone:[ACFaceCheckHelper share].userPhone];
                        };
                    }
                } failed:^(NSError *error) {
                    
                }];
                
                
            } else if([x.queueavailable isEqualToString:@"1"]){//只显示发起面签button
                strongSelf.appointVC.appointmentBtn.hidden = NO;
                strongSelf.appointVC.cancleBtn.hidden = YES;
                strongSelf.appointVC.changeBtn.hidden = YES;
                strongSelf.appointVC.warningLab.hidden = YES;
                strongSelf.appointVC.appointmentBtn.backgroundColor = [UIColor pc_colorWithHexString:kLoginButtonDefault];
                [strongSelf.appointVC.appointmentBtn setTitle:@"发起面核" forState:UIControlStateNormal];
                strongSelf.appointVC.appointmentBtn.userInteractionEnabled = YES;
                strongSelf.appointVC.appointmentBtn.tag = 1001;
                [strongSelf updateViewConstraintsWithLab];
            }else if([x.appointcreate isEqualToString:@"1"]){//只显示预约面签button
                strongSelf.appointVC.appointmentBtn.hidden = NO;
                strongSelf.appointVC.changeBtn.hidden = YES;
                strongSelf.appointVC.cancleBtn.hidden = YES;
                strongSelf.appointVC.warningLab.hidden = YES;
                strongSelf.appointVC.appointmentBtn.backgroundColor = [UIColor pc_colorWithHexString:kLoginButtonDefault];
                [strongSelf.appointVC.appointmentBtn setTitle:@"预约面核" forState:UIControlStateNormal];
                strongSelf.appointVC.appointmentBtn.userInteractionEnabled = YES;
                strongSelf.appointVC.appointmentBtn.tag = 2001;
                if ([x.isPassToday isEqualToString:@"1"]) {//放鸽子
                    [strongSelf updateViewConstraintsTwoLabel];
                }else{
                    [strongSelf hideTitleLab];
                }
            }else if([x.appointupdate isEqualToString:@"1"]){//显示取消预约、申请改期button，发起面签button置灰
                strongSelf.appointVC.appointmentBtn.hidden = NO;
                strongSelf.appointVC.changeBtn.hidden = NO;
                strongSelf.appointVC.cancleBtn.hidden = NO;
                strongSelf.appointVC.warningLab.hidden = YES;
                strongSelf.appointVC.appointmentBtn.backgroundColor = [UIColor pc_colorWithHexString:kLoginButtonDisabled];
                strongSelf.appointVC.appointmentBtn.userInteractionEnabled = NO;
                strongSelf.appointVC.changeBtn.userInteractionEnabled = YES;
                strongSelf.appointVC.cancleBtn.userInteractionEnabled = YES;
                [strongSelf.appointVC.appointmentBtn setTitle:@"发起面核" forState:UIControlStateNormal];
                strongSelf.appointVC.appointmentBtn.tag = 1001;
                [strongSelf updateViewConstraintsWithLab];
            }else{//置灰预约面签 其他不显示
                strongSelf.appointVC.appointmentBtn.hidden = NO;
                strongSelf.appointVC.changeBtn.hidden = YES;
                strongSelf.appointVC.cancleBtn.hidden = YES;
                strongSelf.appointVC.warningLab.hidden = YES;
                //                self.appointVC.appointmentBtn.backgroundColor = [UIColor colorWithHexString:kLoginButtonDisabled];
                //                self.appointVC.appointmentBtn.userInteractionEnabled = NO;
                [strongSelf.appointVC.appointmentBtn setTitle:@"预约面核" forState:UIControlStateNormal];
                strongSelf.appointVC.appointmentBtn.tag = 2001;
                // [self hideTitleLab];
                [strongSelf updateViewConstraintsTwoLabel];
                
                [strongSelf pollAfterGetLastAppointmentRequest];
                
            }
            
        }
        
    } failed:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showToast:error.domain];
        if (error.code != 1003) {
            [strongSelf pollAfterGetLastAppointmentRequest];
        }
    }];
}
-(void)updateViewConstraintsWithLab{
    self.appointVC.titleLab.hidden = NO;
    self.appointVC.limitLab.hidden = NO;
    self.appointVC.promptLab.hidden = NO;
    __weak typeof(self)weakSelf = self;
    [self.appointVC.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.appointVC.bgView.mas_bottom).mas_offset(15);
        make.height.equalTo(@20);
    }];
    [self.appointVC.limitLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.appointVC.titleLab.mas_bottom).mas_offset(5);
        make.height.equalTo(@20);
    }];
    [self.appointVC.promptLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.appointVC.limitLab.mas_bottom).mas_offset(5);
        make.height.equalTo(@20);
    }];
}

- (void)updateViewConstraintsTwoLabel {
    self.appointVC.titleLab.hidden = YES;
    self.appointVC.limitLab.hidden = NO;
    self.appointVC.promptLab.hidden = NO;
    __weak typeof(self)weakSelf = self;
    [self.appointVC.limitLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.appointVC.bgView.mas_bottom).mas_offset(15);
        make.height.equalTo(@20);
    }];
    [self.appointVC.promptLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.appointVC.limitLab.mas_bottom).mas_offset(5);
        make.height.equalTo(@20);
    }];
    [self.appointVC.appointmentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.appointVC.promptLab.mas_bottom).mas_offset(20);
    }];
    
    self.appointVC.limitLab.text = @"由于客户未能在预约时间参与面核，请重新预约";
    self.appointVC.promptLab.text = @"（今日时段不可预约）";
}

-(void)hideTitleLab{
    self.appointVC.titleLab.hidden = YES;
    self.appointVC.limitLab.hidden = YES;
    self.appointVC.promptLab.hidden = YES;
}
-(ACAppointmentViewModel *)appointViewModel{
    if (!_appointViewModel) {
        _appointViewModel = [[ACAppointmentViewModel alloc]init];
    }
    return _appointViewModel;
}
//网络监测
-(void)reachabilityStatusMonitoring{
    __weak typeof(self)weakSelf = self;
    [self reachabilityStatusWithAFNetworkingWithToast:NO WithBlock:^(BOOL isNet) {
        if (isNet) {
            
        }else{
            [[ACAlertManager shareAlertManager] showAlertMessageWithOneContent:@"网络连接失败，请检查网络！" actiontitle:@"确定" okeyAction:^{
                  [self removeViewAndController];
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];

        }
    }];
    
    
}




@end
