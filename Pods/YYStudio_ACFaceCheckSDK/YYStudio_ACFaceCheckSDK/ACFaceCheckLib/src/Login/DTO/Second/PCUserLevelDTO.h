//
//  PCUserLevelDTO.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/18.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseDTO.h"

@interface PCUserLevelDTO : ACBaseDTO

@property (nonatomic, copy) NSString *userLevel;

@end

/**
 权限             资源                 备注
 OTP	 	                         初始用户
 PWD	         个人中心	             设置密码的用户
 IDCARD	      个人中心||查看订单	     登录手机号与贷款订单身份证号一一对应
 IDCARDAUTH	  个人中心||查看订单	     身份证通过了银行卡鉴权
 PAY	     个人中心||查看订单||支付	 银行卡鉴权（目前无）
 权限序列	   OTP|PWD|IDCARD|IDCARDAUTH|PAY	11111
 */
