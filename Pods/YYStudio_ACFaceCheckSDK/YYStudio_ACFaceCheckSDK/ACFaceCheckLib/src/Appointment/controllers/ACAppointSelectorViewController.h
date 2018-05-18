//
//  ACAppointSelectorViewController.h
//  ACFaceCheckLib
//
//  Created by Miaoz on 2018/4/9.
//  Copyright © 2018年 . All rights reserved.
//

#import "ACBaseViewController.h"
#import "ACFaceCheckHelper.h"
@class ACMyLastAppointDTO;

@interface ACAppointSelectorViewController : ACBaseViewController
@property(nonatomic, strong)NSDictionary *dic;
@property(nonatomic, strong)ACMyLastAppointDTO *lastAppointDTO;
@property(nonatomic, assign)ACFaceCheckOrderAppointState orderAppointState;
@end
