//
//  ACAppointSelectorViewController.m
//  ACFaceCheckLib
//
//  Created by Miaoz on 2018/4/9.
//  Copyright © . All rights reserved.
//

#import "ACAppointSelectorViewController.h"
#import "ACAppointSelectorView.h"
#import "ACAppointmentViewModel.h"
#import "ACAvailableListDTO.h"
#import <Masonry/Masonry.h>
#import "ACAlertManager.h"
#import "NSDate+Addtion.h"
#import "UIFont+Addtion.h"
#import "ACMyLastAppointDTO.h"

@interface ACAppointSelectorViewController ()<ACAppointSelectorDelegate>
@property(nonatomic,strong)ACAppointmentViewModel *appointViewModel;
@property(nonatomic,strong)ACAvailableListDTO *availableListDTO;
@property (nonatomic, strong) ACAppointSelectorView *appointSelectorView;
@end

@implementation ACAppointSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    if (self.orderAppointState == ACFaceCheckOrderAppointState_appointupdate) {
         [self addRightBarButton];
    }
    
    [self initAndModifySubviews];
    
     [self getAvailableListDate:_lastAppointDTO.isPassToday];

    self.appointSelectorView.lastAppointDTO = self.lastAppointDTO;
    
}

#pragma mark - private Methods
- (void)addRightBarButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"放弃预约" style:UIBarButtonItemStylePlain target:self action:@selector(giveUpAppoint)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor pc_colorWithHexString:Color2264F4]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont pingFangSCRegularWithSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
     [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont pingFangSCRegularWithSize:14],NSFontAttributeName, nil] forState:UIControlStateHighlighted];
}


- (void) initAndModifySubviews {
    [self.view addSubview:self.appointSelectorView];
    [_appointSelectorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - getter&setter

- (ACAppointSelectorView *)appointSelectorView {
    if (!_appointSelectorView) {
        self.appointSelectorView = [[ACAppointSelectorView alloc] init];
        _appointSelectorView.delegate = self;
    }
    
    return _appointSelectorView;
}

-(ACAppointmentViewModel *)appointViewModel{
    if (!_appointViewModel) {
        _appointViewModel = [[ACAppointmentViewModel alloc]init];
    }
    return _appointViewModel;
}

- (void)setLastAppointDTO:(ACMyLastAppointDTO *)lastAppointDTO {
    _lastAppointDTO = lastAppointDTO;

}

- (void)setOrderAppointState:(ACFaceCheckOrderAppointState)orderAppointState {
    _orderAppointState = orderAppointState;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- action
- (void)giveUpAppoint {
    
    __weak typeof(self) weakSelf = self;
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@",[NSDate dateFormatterTimeNomalWithTime:self.lastAppointDTO.starttime],[NSDate dateFormatterTimeNomalWithTime:self.lastAppointDTO.endtime]];
    NSString *content = [NSString stringWithFormat:@"您将放弃已成功预约的面核时间\n%@\n选择放弃，您需要重新预约",dateStr];
    [[ACAlertManager shareAlertManager] showAlertMessageWithTitle:@"重要！" content:content okeyTitle:@"取消" okeyAction:^{
       
    } cancelTitle:@"放弃" cancelAction:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf cancleAppointWithAppointno:strongSelf.lastAppointDTO.appointno appointSecretKey:self.lastAppointDTO.appointsecretkey];
    }];
    
}

#pragma mark --ACAppointSelectorDelegate

- (void)confirmAppointSelectTime:(ACAvailableDayDTO *)availableDayDTO availableDTO:(ACAvailableDTO *)availableDTO {

    if ([availableDTO.availablecount integerValue] == 0) {
       [self showToast:@"该预约人数已满，请选择其他时间"];
         
        } else {
            __weak typeof(self) weakSelf = self;
            NSString *dateStr = [NSString stringWithFormat:@"%@-%@",availableDTO.starttime,availableDTO.endtime];
            NSString *content = [NSString stringWithFormat:@"确认选择%@时间段进行面核？",dateStr];
            [[ACAlertManager shareAlertManager] showAlertMessageWithTitle:@"温馨提示" content:content okeyTitle:@"取消" okeyAction:^{
                
            } cancelTitle:@"确认" cancelAction:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf.orderAppointState == ACFaceCheckOrderAppointState_appointInterview ||strongSelf.orderAppointState == ACFaceCheckOrderAppointState_overdueappoint) {
                    [strongSelf creatAppointlWithOrderId:[strongSelf.dic valueForKey:@"orderId"] appointDate:[NSDate onlydateFormatterWithTime: availableDayDTO.appointdate] slot:availableDTO.slot productName:[strongSelf.dic valueForKey:@"ordertype"]];
                } else if (strongSelf.orderAppointState == ACFaceCheckOrderAppointState_appointupdate) {
                    [strongSelf changeAppointWithAppointno:strongSelf.lastAppointDTO.appointno appointSecretKey:strongSelf.lastAppointDTO.appointsecretkey appointDate:[NSDate onlydateFormatterWithTime: availableDayDTO.appointdate]slot:availableDTO.slot];
                }
            }];
        }
}

#pragma mark -- 接口
//获取预约选择时间
-(void)getAvailableListDate:(NSString *)isPassToday{
    __weak typeof(self) weakSelf = self;
    [self.appointViewModel getAvailableListDateRequestSignalWithisPassToday:isPassToday success:^(id responseDTO) {
         __strong typeof(weakSelf) strongSelf = weakSelf;
        ACAvailableListDTO * x = (ACAvailableListDTO *)responseDTO;
        strongSelf.availableListDTO = x;
        [strongSelf.appointSelectorView updateDataSource:x];
        
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
        [strongSelf goBackViewControllerWithIsRoot:YES];
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
        [strongSelf goBackViewControllerWithIsRoot:YES];
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
        [strongSelf goBackViewControllerWithIsRoot:YES];
    } failed:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showToast:error.domain];
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
