//
//  ACFaceCheckHelper.h
//  ACFaceCheckLib
//
//  Created by Miaoz on 2017/11/22.
//  Copyright © 2017年 Miaoz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ACAppointmentViewModel.h"
#import "ACBaseDTO.h"
#import "ACBaseViewModel.h"
#import "ACMyLastAppointDTO.h"
#import "ACCreatAppointDTO.h"
#import "ACAvailableListDTO.h"


typedef NS_ENUM(NSUInteger, ACFaceCheckEnvironment) {
    ACFaceCheckEnvironment_stg, //测试环境
    ACFaceCheckEnvironment_prd, //发布环境
    ACFaceCheckEnvironment_dev, //开发环境
};
typedef NS_ENUM(NSUInteger, ACFaceCheckOrderAppointState) {
    ACFaceCheckOrderAppointState_isqueuing, //排队中
    ACFaceCheckOrderAppointState_queuingInother, //在其他队列中排队
    ACFaceCheckOrderAppointState_vailableInterview, //发起面签
    ACFaceCheckOrderAppointState_appointInterview, //预约面签
    ACFaceCheckOrderAppointState_overdueappoint, //预约过期 放鸽子
    ACFaceCheckOrderAppointState_appointupdate, //显示取消预约、申请改期
    ACFaceCheckOrderAppointState_appointDefault, //除了以上所有子状态的标示
};
typedef NS_ENUM(NSUInteger, ACFaceCheckInputType) {
    ACFaceCheckInputType_push, //push进入
    ACFaceCheckInputType_present, //present进入
};

typedef void(^CallBackBlcok) (BOOL isSuccess, NSError *error);

@interface ACFaceCheckHelper : NSObject

typedef ACFaceCheckHelper *(^ ACFaceCheckConfig)(void);
typedef ACFaceCheckHelper *(^ACFaceCheckConfigToBool)(BOOL is);
typedef ACFaceCheckHelper *(^ACFaceCheckConfigToInteger)(NSInteger number);
typedef ACFaceCheckHelper *(^ACFaceCheckConfigToFloat)(CGFloat number);
typedef ACFaceCheckHelper *(^ACFaceCheckConfigToString)(NSString *str);
typedef ACFaceCheckHelper *(^ACFaceCheckConfigToDic)(NSDictionary *dic);
typedef ACFaceCheckHelper *(^ACFaceCheckConfigToEnvironment)(ACFaceCheckEnvironment environment);


@property (nonatomic, copy) NSString *barColor;
@property (nonatomic, copy) NSString *barTitleColor;
@property (nonatomic, assign) NSInteger barTitleFontSize;
@property (nonatomic, copy) NSString *tintColor;
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *userPassWord;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *reloginKey;
//anychat帮助页面链接
@property (nonatomic, copy) NSString *yjkProductInfo;
@property (nonatomic, assign) ACFaceCheckEnvironment environment;
@property (nonatomic, assign) ACFaceCheckOrderAppointState orderAppointState;
/*传递信息*/
@property (nonatomic, strong)NSDictionary *dataInfo;
+ (instancetype)share;
/**链式调用**/
@property (nonatomic, copy) ACFaceCheckConfigToDic setDataInfo;
@property (nonatomic, copy) ACFaceCheckConfigToEnvironment setEnvironment;
@property (nonatomic, copy) ACFaceCheckConfigToString setBarColor;
@property (nonatomic, copy) ACFaceCheckConfigToString setBarTitleColor;
@property (nonatomic, copy) ACFaceCheckConfigToInteger setBarTitleFontSize;
@property (nonatomic, copy) ACFaceCheckConfigToString setTintColor;
@property (nonatomic, copy) ACFaceCheckConfigToString setUserPhone;
@property (nonatomic, copy) ACFaceCheckConfigToString setUserPassWord;
@property (nonatomic, copy) ACFaceCheckConfigToString setUserName;
@property (nonatomic, copy) ACFaceCheckConfigToString setReloginKey;
@property (nonatomic, copy) ACFaceCheckConfig start;
/*单独登录时需要调用*/
@property (nonatomic, copy) ACFaceCheckConfig login;

@property (nonatomic,copy)CallBackBlcok callBackBlcok;

/*
 获取订单状态接口封装
 orderInfo:传入关于订单的信息
 例：
            key :orderId
            key : ordertype
 otherInfo:要透传给我们的订单信息
 例：
            key :orderId
            key : ordertype
 success:成功后返回当前订单状态及订单关于预约模块的信息
 failed:失败错误返回
 */
-(void)orderWithAppointStateWithOrderInfo:(NSDictionary *)orderDic success:(void (^)(ACFaceCheckOrderAppointState orderAppointState, id acMyLastAppointDTO, NSDictionary *otherInfo))success failed:(void (^)(NSError *error))failed;
/*
 跳转到排队等待轮询界面
 */
- (void)enterQueueVCWithFromVC:(UIViewController *)vc inputType:(ACFaceCheckInputType)type ;
/*
 跳转到预约选择列表
 orderInfo: key :orderId
            key : ordertype
 */
- (void)enterAppointSelectorVCWithFromVC:(UIViewController *)vc inputType:(ACFaceCheckInputType)type ACFaceCheckOrderAppointState:(ACFaceCheckOrderAppointState)orderAppointState orderInfo:(NSDictionary *)orderDic;
/*
 离开队列
 */
-(void)leaveQueuesuccess:(void (^)(id responseDTO))success failed:(void(^)(NSError *error))failed;
- (UIViewController *)getHostFromeVC;

@end
