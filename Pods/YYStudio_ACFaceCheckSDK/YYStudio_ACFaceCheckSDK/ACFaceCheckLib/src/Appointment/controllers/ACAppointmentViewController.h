//
//  ACAppointmentViewController.h
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/21.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseViewController.h"
#import "ACMyLastAppointDTO.h"

@interface ACAppointmentViewController : ACBaseViewController
@property(nonatomic,strong)UIButton *appointmentBtn;
@property(nonatomic,strong)UIButton *cancleBtn;
@property(nonatomic,strong)UIButton *changeBtn;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *limitLab;
@property(nonatomic,strong)UILabel *promptLab;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *warningLab;
    
@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,strong)ACMyLastAppointDTO *lastAppointDTO;


@end
