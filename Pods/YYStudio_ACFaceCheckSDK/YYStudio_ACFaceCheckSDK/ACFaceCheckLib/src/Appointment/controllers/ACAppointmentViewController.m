//
//  ACAppointmentViewController.m
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/21.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACAppointmentViewController.h"
#import "ACAppointmentViewModel.h"
#import "ACNNewInterviewViewController.h"
#import "NSDate+Addtion.h"
#import "ACChoiceAppointTimeViewController.h"

#import "UIColor+Addtion.h"

#import "ACAppointSelectorViewController.h"
#import "ACFaceCheckHelper.h"

@interface ACAppointmentViewController ()<PCChoiceAppointTimeDelegate>

@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UILabel *orderIdLab;
@property(nonatomic,strong)UILabel *orderIdContent;
@property(nonatomic,strong)UILabel *dateLab;
@property(nonatomic,strong)UILabel *dateLabContent;
@property(nonatomic,strong)UILabel *stateLab;
@property(nonatomic,strong)UILabel *stateLabContent;
@property(nonatomic,strong)UILabel *moneyLab;
@property(nonatomic,strong)UILabel *moneyLabContent;
@property(nonatomic,strong)UILabel *timeLab;
@property(nonatomic,strong)UILabel *timeLabContent;

//no 表示发起预约 yes 表示更改预约
@property(nonatomic,assign)BOOL isChange;
 
@property(nonatomic,strong)ACChoiceAppointTimeViewController *appointTimeVC;
@property(nonatomic,strong)ACAppointmentViewModel *appointViewModel;
@property(nonatomic,strong)ACAvailableListDTO *availableListDTO;

@property(nonatomic,assign)float titleHeight;
@property (nonatomic, strong) NSDictionary *orderLinkPrefixDic;
@end

@implementation ACAppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self creatUI];
    [self writeDataToLable];
    [self getAvailableListDate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"订单详情";
    self.navigationItem.title = @"订单详情";
}

- (void)creatUI{
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor pc_colorWithHexString:@"#e5e5e5"];
    [self.bgView addSubview:self.lineView];
   
    self.orderIdLab = [[UILabel alloc]init];
    self.orderIdLab.userInteractionEnabled = YES;
    self.orderIdLab.textAlignment = NSTextAlignmentLeft;
    self.orderIdLab.font = [UIFont systemFontOfSize:14];
    self.orderIdLab.textColor = [UIColor pc_colorWithHexString:@"#999999"];
    [self.bgView addSubview:self.orderIdLab];
    self.orderIdContent = [[UILabel alloc]init];
    self.orderIdContent.userInteractionEnabled = YES;
    self.orderIdContent.textAlignment = NSTextAlignmentRight;
    self.orderIdContent.font = [UIFont systemFontOfSize:14];
    [self.bgView addSubview:self.orderIdContent];
    
    self.dateLab = [[UILabel alloc]init];
    self.dateLab.textAlignment = NSTextAlignmentLeft;
    self.dateLab.userInteractionEnabled = YES;
    self.dateLab.font = [UIFont systemFontOfSize:14];
    self.dateLab.textColor = [UIColor pc_colorWithHexString:@"#999999"];
    [self.bgView addSubview:self.dateLab];
    self.dateLabContent = [[UILabel alloc]init];
    self.dateLabContent.userInteractionEnabled = YES;
    self.dateLabContent.font = [UIFont systemFontOfSize:14];
    self.dateLabContent.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:self.dateLabContent];
    
    self.stateLab = [[UILabel alloc]init];
    self.stateLab.textAlignment = NSTextAlignmentLeft;
    self.stateLab.userInteractionEnabled = YES;
    self.stateLab.font = [UIFont systemFontOfSize:14];
    self.stateLab.textColor = [UIColor pc_colorWithHexString:@"#999999"];
    [self.bgView addSubview:self.stateLab];
    self.stateLabContent = [[UILabel alloc]init];
    self.stateLabContent.userInteractionEnabled = YES;
    self.stateLabContent.font = [UIFont systemFontOfSize:14];
    self.stateLabContent.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:self.stateLabContent];
    
    self.moneyLab = [[UILabel alloc]init];
    self.moneyLab.textAlignment = NSTextAlignmentLeft;
    self.moneyLab.userInteractionEnabled = YES;
    self.moneyLab.font = [UIFont systemFontOfSize:14];
    self.moneyLab.textColor = [UIColor pc_colorWithHexString:@"#999999"];
    [self.bgView addSubview:self.moneyLab];
    self.moneyLabContent = [[UILabel alloc]init];
    self.moneyLabContent.userInteractionEnabled = YES;
    self.moneyLabContent.font = [UIFont systemFontOfSize:14];
    self.moneyLabContent.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:self.moneyLabContent];
    
    self.timeLab = [[UILabel alloc]init];
    self.timeLab.textAlignment = NSTextAlignmentLeft;
    self.timeLab.userInteractionEnabled = YES;
    self.timeLab.font = [UIFont systemFontOfSize:14];
    self.timeLab.textColor = [UIColor pc_colorWithHexString:@"#999999"];
    [self.bgView addSubview:self.timeLab];
    self.timeLabContent = [[UILabel alloc]init];
    self.timeLabContent.userInteractionEnabled = YES;
    self.timeLabContent.font = [UIFont systemFontOfSize:14];
    self.timeLabContent.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:self.timeLabContent];
    
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.font = [UIFont systemFontOfSize:16];
    self.titleLab.userInteractionEnabled = YES;
    [self.view addSubview:self.titleLab];
    self.limitLab = [[UILabel alloc]init];
    self.limitLab.userInteractionEnabled = YES;
    self.limitLab.font = [UIFont systemFontOfSize:14];
    self.limitLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.limitLab];
    self.promptLab = [[UILabel alloc]init];
    self.promptLab.userInteractionEnabled = YES;
    self.promptLab.font = [UIFont systemFontOfSize:14];
    self.promptLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.promptLab];
    
    self.warningLab = [[UILabel alloc]init];
    self.warningLab.userInteractionEnabled = NO;
    self.warningLab.numberOfLines = 0;
    self.warningLab.font = [UIFont systemFontOfSize:14];
    self.warningLab.textAlignment = NSTextAlignmentCenter;
    
//    self.orderLinkPrefixDic = (NSDictionary*)[[EGOCache globalCache] objectForKey:kOrderDtailLinkPrefixKey];
//    NSDictionary *sysconf = [self.orderLinkPrefixDic objectForKey:@"sysconf"];
//    NSString *str = [sysconf objectForKey:@"appoint_expired_msg"];
    self.warningLab.text = @"warningLab";
    CGSize titleSize = [self.warningLab.text boundingRectWithSize:CGSizeMake(ACNScreenWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    self.titleHeight = titleSize.height;
    [self.view addSubview:self.warningLab];
    __weak typeof(self)weakSelf = self;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@(ACNScreenWidth));
        make.height.equalTo(@220);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@(ACNScreenWidth));
        make.height.equalTo(@0.5);
    }];
    
    [self.orderIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@(20));
        make.height.equalTo(@20);
    }];
    [self.orderIdContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.right.equalTo(@(-20));
        make.height.equalTo(@20);
    }];
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.orderIdContent.mas_bottom).mas_offset(20);
        make.left.equalTo(@(20));
        make.width.equalTo(@(100));
        make.height.equalTo(@20);
    }];
    [self.dateLabContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.orderIdContent.mas_bottom).mas_offset(20);
        make.right.equalTo(@(-20));
        make.width.equalTo(@(ACNScreenWidth-40-100));
        make.height.equalTo(@20);
    }];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.dateLabContent.mas_bottom).mas_offset(20);
        make.left.equalTo(@(20));
        make.width.equalTo(@(100));
        make.height.equalTo(@20);
    }];
    [self.stateLabContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.dateLabContent.mas_bottom).mas_offset(20);
        make.right.equalTo(@(-20));
        make.width.equalTo(@(ACNScreenWidth-40-100));
        make.height.equalTo(@20);
    }];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.stateLabContent.mas_bottom).mas_offset(20);
        make.left.equalTo(@(20));
        make.width.equalTo(@(100));
        make.height.equalTo(@20);
    }];
    [self.moneyLabContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.stateLabContent.mas_bottom).mas_offset(20);
        make.right.equalTo(@(-20));
        make.width.equalTo(@(ACNScreenWidth-40-100));
        make.height.equalTo(@20);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.moneyLabContent.mas_bottom).mas_offset(20);
        make.left.equalTo(@(20));
        make.width.equalTo(@(100));
        make.height.equalTo(@20);
    }];
    [self.timeLabContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.moneyLabContent.mas_bottom).mas_offset(20);
        make.right.equalTo(@(-20));
        make.width.equalTo(@(ACNScreenWidth-40-100));
        make.height.equalTo(@20);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgView.mas_bottom).mas_offset(0);
        make.right.equalTo(@(0));
        make.width.equalTo(@(ACNScreenWidth));
        make.height.equalTo(@0);
    }];
    [self.limitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLab.mas_bottom).mas_offset(0);
        make.right.equalTo(@(0));
        make.width.equalTo(@(ACNScreenWidth));
        make.height.equalTo(@0);
    }];
    [self.promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.limitLab.mas_bottom).mas_offset(0);
        make.right.equalTo(@(0));
        make.width.equalTo(@(ACNScreenWidth));
        make.height.equalTo(@0);
    }];
    [self.appointmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.promptLab.mas_bottom).mas_offset(20);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.equalTo(@240);
        make.height.equalTo(@48);
    }];
    [self.warningLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.appointmentBtn.mas_bottom).mas_offset(10);
        make.left.equalTo(@(20));
        make.width.equalTo(@(ACNScreenWidth-40));
        make.height.equalTo(@(weakSelf.titleHeight));
    }];

    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.appointmentBtn.mas_bottom).mas_offset(20);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.equalTo(@240);
        make.height.equalTo(@48);
    }];
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.cancleBtn.mas_bottom).mas_offset(20);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.equalTo(@240);
        make.height.equalTo(@48);
    }];
    
}
-(void)writeDataToLable{
    self.orderIdLab.text = @"订单号";
    self.dateLab.text = @"申请时间";
    self.stateLab.text = @"订单状态";
    self.moneyLab.text = @"贷款金额";
    self.timeLab.text = @"申请期限";
    
    self.orderIdContent.text = [self.dic valueForKey:@"orderId"];
    self.dateLabContent.text = [self.dic valueForKey:@"date"];
    self.stateLabContent.text = [self.dic valueForKey:@"status"];
    self.moneyLabContent.text = [NSString stringWithFormat:@"%@元",[self.dic valueForKey:@"sum"]];
    self.timeLabContent.text = [self.dic valueForKey:@"description"];
    
    self.titleLab.text = @"您已预约成功！";
    NSString *start =[NSDate dateFormatterDayNomalWithTime:self.lastAppointDTO.starttime];
    NSString *end =[NSDate dateFormatterTimeNomalWithTime:self.lastAppointDTO.endtime];
    self.limitLab.text = [NSString stringWithFormat:@"预约时段：%@-%@",start,end];
    self.promptLab.text = @"请关注";
    
}
-(UIButton *)appointmentBtn{
    if (!_appointmentBtn) {
        self.appointmentBtn = [[UIButton alloc]init];
        self.appointmentBtn.layer.cornerRadius = 24;
        self.appointmentBtn.tag = 1001;
        self.appointmentBtn.backgroundColor = [UIColor pc_colorWithHexString:kLoginButtonDefault];
//        self.appointmentBtn.hidden = YES;
        [self.appointmentBtn setTitle:@"发起面核" forState:UIControlStateNormal];
        [self.appointmentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_appointmentBtn];
    }
    return _appointmentBtn;
}
-(UIButton *)cancleBtn{
    if (!_cancleBtn) {
        self.cancleBtn = [[UIButton alloc]init];
        self.cancleBtn.layer.cornerRadius = 24;
        self.cancleBtn.tag = 1002;
        self.cancleBtn.layer.borderWidth = 1;
        self.cancleBtn.layer.borderColor = [UIColor pc_colorWithHexString:kLoginButtonDefault].CGColor;
        self.cancleBtn.backgroundColor = [UIColor whiteColor];
//        self.cancleBtn.hidden = YES;
        [self.cancleBtn setTitle:@"取消预约" forState:UIControlStateNormal];
        [self.cancleBtn setTitleColor:[UIColor pc_colorWithHexString:kLoginButtonDefault] forState:UIControlStateNormal];
        [self.cancleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancleBtn];
    }
    return _cancleBtn;
}
-(UIButton *)changeBtn{
    if (!_changeBtn) {
        self.changeBtn = [[UIButton alloc]init];
        self.changeBtn.layer.cornerRadius = 24;
        self.changeBtn.tag = 1003;
        self.changeBtn.layer.borderWidth = 1;
        self.changeBtn.layer.borderColor = [UIColor pc_colorWithHexString:kLoginButtonDefault].CGColor;
        self.changeBtn.backgroundColor = [UIColor whiteColor];
//        self.changeBtn.hidden = YES;
        [self.changeBtn setTitle:@"申请改期" forState:UIControlStateNormal];
        [self.changeBtn setTitleColor:[UIColor pc_colorWithHexString:kLoginButtonDefault] forState:UIControlStateNormal];
        [self.changeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_changeBtn];
    }
    return _changeBtn;
}
-(void)btnClick:(UIButton *)btn{
    
   
    switch (btn.tag) {
        case 1001://发起面签
        {
//            [self joinAppointWithOrderId:self.lastAppointDTO.appointno appointSecretKey:self.lastAppointDTO.appointsecretkey];
            ACNNewInterviewViewController *acnVC = [[ACNNewInterviewViewController alloc]init];
            acnVC.lastAppointDTO = self.lastAppointDTO;
            [self.navigationController pushViewController:acnVC animated:YES];
        }
        break;
        case 2001://预约面签
        {
//            self.isChange = NO;
//            [self getAvailableListDate];
//            self.appointTimeVC =[[ACChoiceAppointTimeViewController alloc]initWithAppointTimeDelegate:self];
//            [self.appointTimeVC presentAppointTimeViewWithController:self.navigationController];
     
            ACAppointSelectorViewController *vcc = [[ACAppointSelectorViewController alloc] init];
            vcc.lastAppointDTO = self.lastAppointDTO;
            vcc.dic = self.dic;
            vcc.orderAppointState = ACFaceCheckOrderAppointState_appointInterview;
            [self.navigationController pushViewController:vcc animated:YES];
        }
        break;
        case 1002://取消预约
        {
            [self cancleAppointWithAppointno:self.lastAppointDTO.appointno appointSecretKey:self.lastAppointDTO.appointsecretkey];
            
//            ACAppointSelectorViewController *vcc = [[ACAppointSelectorViewController alloc] init];
//            vcc.lastAppointDTO = self.lastAppointDTO;
//            vcc.dic = self.dic;
//            vcc.orderAppointState = ACFaceCheckOrderAppointState_appointupdate;
//            [self.navigationController pushViewController:vcc animated:YES];
        }
        break;
        case 1003://申请改期
        {
            
//            self.isChange = YES;
//            [self getAvailableListDate];
//            self.appointTimeVC =[[ACChoiceAppointTimeViewController alloc]initWithAppointTimeDelegate:self];
//            [self.appointTimeVC presentAppointTimeViewWithController:self.navigationController];
            
            ACAppointSelectorViewController *vcc = [[ACAppointSelectorViewController alloc] init];
            vcc.lastAppointDTO = self.lastAppointDTO;
            vcc.dic = self.dic;
            vcc.orderAppointState = ACFaceCheckOrderAppointState_appointupdate;
            [self.navigationController pushViewController:vcc animated:YES];
        }
        break;
       
        default:
        break;
    }
}
#pragma mark -- 接口
//获取预约选择时间
-(void)getAvailableListDate{
    __weak typeof(self) weakSelf = self;
    [self.appointViewModel getAvailableListDateRequestSignalWithisPassToday:self.lastAppointDTO.isPassToday success:^(id responseDTO) {
        ACAvailableListDTO * x = (ACAvailableListDTO *)responseDTO;
        self.availableListDTO = x;
        if (self.appointTimeVC) {
            [self.appointTimeVC updateDataSource:x];
        }
        
    } failed:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showToast:error.domain];
    }];
}
//预约面签
-(void)creatAppointlWithOrderId:(NSString *)orderId appointDate:(NSString *)date slot:(NSString *)slot productName:(NSString *)productName{
    __weak typeof(self) weakSelf = self;
    [self.appointViewModel creatAppointRequestSignalWithOrderId:orderId appointDate:date slot:slot productName:productName success:^(id responseDTO) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showToast:@"预约成功！"];
         [strongSelf ac_hideCurrentViewController];
    } failed:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showToast:error.domain];
    }];
}
//取消预约
-(void)cancleAppointWithAppointno:(NSString *)appointno appointSecretKey:(NSString *)appointSecretKey{
    __weak typeof(self) weakSelf = self;
    [self.appointViewModel cancleAppointRequestSignalWithAppointno:appointno appointSecretKey:appointSecretKey success:^(id responseDTO) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showToast:@"取消预约成功！"];
         [strongSelf ac_hideCurrentViewController];
    } failed:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showToast:error.domain];
    }];
}
//预约改期
-(void)changeAppointWithAppointno:(NSString *)appointno appointSecretKey:(NSString *)appointSecretKey appointDate:(NSString *)date slot:(NSString *)slot{
    __weak typeof(self) weakSelf = self;
    [self.appointViewModel changeAppointRequestSignalWithAppointno:appointno appointSecretKey:appointSecretKey appointDate:date slot:slot success:^(id responseDTO) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showToast:@"预约改期成功！"];
        [strongSelf ac_hideCurrentViewController];
    } failed:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showToast:error.domain];
    }];
    
}
    //发起面签
-(void)joinAppointWithOrderId:(NSString *)orderId appointSecretKey:(NSString *)appointSecretKey{
    __weak typeof(self) weakSelf = self;
    [self.appointViewModel joinAppointRequestSignalWithOrderId:orderId appointSecretKey:appointSecretKey success:^(id responseDTO) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        ACNNewInterviewViewController *acnVC = [[ACNNewInterviewViewController alloc]init];
        [strongSelf.navigationController pushViewController:acnVC animated:YES];
    } failed:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showToast:error.domain];
    }];
}

#pragma mark - private Methods

- (void)ac_hideCurrentViewController {
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark PCChoiceAppointTimeDelegate
//    选择预约日期后的回调
- (void)confirmChoiceAppointTime:(NSString *)appointDate availableDTO:(ACAvailableDTO*)availableDTO{
    if (self.isChange) {
        [self changeAppointWithAppointno:self.lastAppointDTO.appointno appointSecretKey:self.lastAppointDTO.appointsecretkey appointDate:[NSDate onlydateFormatterWithTime: appointDate]slot:availableDTO.slot];
    }else{
        [self creatAppointlWithOrderId:[self.dic valueForKey:@"orderId"] appointDate:[NSDate onlydateFormatterWithTime: appointDate] slot:availableDTO.slot productName:[self.dic valueForKey:@"ordertype"]];
    }
    
}
//    点击某一个日期后，供外界刷新数据
//- (void)refreshChoiceAppointTimeWithDayIndex:(NSInteger)dayIndex Complete:(AppointTimeRefreshComplete)complete{
//    
//}
    
    
-(ACAppointmentViewModel *)appointViewModel{
    if (!_appointViewModel) {
        _appointViewModel = [[ACAppointmentViewModel alloc]init];
    }
    return _appointViewModel;
}

    
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.editing = NO;
}
@end
