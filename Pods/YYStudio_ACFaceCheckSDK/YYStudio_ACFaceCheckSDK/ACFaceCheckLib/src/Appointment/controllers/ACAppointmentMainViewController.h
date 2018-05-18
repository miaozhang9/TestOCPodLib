//
//  PCAppointmentMainViewController.h
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/21.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseViewController.h"

@interface ACAppointmentMainViewController : ACBaseViewController

@property(nonatomic,strong)NSDictionary *dic;
//刷新视图
- (void)refreshUI;
@end
