//
//  PCNetFailView.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/6/1.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACNetFailView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Addtion.h"

@interface ACNetFailView ()

@property (nonatomic, weak) UILabel *mesLabel;

@end

@implementation ACNetFailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self yzt_setupUI];
        [self yzt_addTapGesture];
        self.mesLabel.text = @"链接获取失败，请点击重试";
    }
    return self;
}
#pragma mark private
- (void)yzt_setupUI
{
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"QHLoanDoorBundle.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    imageView.image = [UIImage imageNamed:@"requestFailed" inBundle:bundle compatibleWithTraitCollection:nil];
    [self addSubview:imageView];
    __weak typeof(self) weakself = self;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself);
        make.bottom.equalTo(weakself.mas_centerY);
    }];
    
    UILabel *messageLab = [[UILabel alloc] init];
    messageLab.font = [UIFont systemFontOfSize:14];
    messageLab.textColor = [UIColor pc_colorWithHex:0x9b9b9b];
    messageLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:messageLab];
    [messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(20);
        make.centerX.equalTo(weakself);
    }];
    self.mesLabel = messageLab;
}

- (void)yzt_addTapGesture
{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureEvent:)];
    [self addGestureRecognizer:tapGesture];
    
}
#pragma mark event response
- (void)tapGestureEvent:(UITapGestureRecognizer *)tapGesture
{
    if ([self.delegate respondsToSelector:@selector(netFailView:didClickGesture:)]) {
        [self.delegate netFailView:self didClickGesture:tapGesture];
    }
}

#pragma mark setter and getter
- (void)setMessageStr:(NSString *)messageStr
{
    _messageStr = messageStr;
    self.mesLabel.text = messageStr;
}


@end
