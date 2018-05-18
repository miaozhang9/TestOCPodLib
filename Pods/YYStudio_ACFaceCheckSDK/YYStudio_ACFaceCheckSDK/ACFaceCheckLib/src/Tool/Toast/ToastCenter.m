//
//  ToastCenter.m
//  ToastDemo
//
//  Created by 黄世光 on 2016/11/23.
//  Copyright © 2016年 黄世光. All rights reserved.
//

#import "ToastCenter.h"
#import "ToastView.h"
#define ToastFont 14 //字体大小
#define mainWidth       [[UIScreen mainScreen] bounds].size.width
#define ToastH 30 //一行的高度
#define ToastMaxW mainWidth-100 //最长限制
#define ToastFont 14 //字体大小
#define ToastTime 1.5;

@interface ToastCenter()
@property (nonatomic,assign)BOOL active;
@property (nonatomic,strong)ToastView *myToastView;

@property (nonatomic,strong)UIColor *titleColor;
@property (nonatomic,strong)UIColor *bgColor;
@property (nonatomic,assign)CGFloat titleFont;
@property (nonatomic,assign)CGFloat maxWidth;
@property (nonatomic,assign)CGFloat minHeight;
@property (nonatomic,assign)CGFloat time;
@end
@implementation ToastCenter
+(ToastCenter *)defaultCenter{
    static ToastCenter *toastCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!toastCenter) {
            toastCenter = [[ToastCenter alloc]init];
        }
    });
    return toastCenter;
}
-(instancetype)init{
    if (self = [super init]) {
        _active = NO;
        
    }
    return self;
}
-(void)setToastShowTime:(CGFloat)time{
    self.time = time;
}
-(void)setToastStyleWithBgColor:(UIColor *)bgColor andFont:(CGFloat)titleFont andTextColor:(UIColor *)titleColor andToastViewMaxWidth:(CGFloat)maxWidth andTosrViewMinHeight:(CGFloat)minHeight andTime:(CGFloat)time{
    self.bgColor = bgColor;
    self.titleFont = titleFont;
    self.titleColor = titleColor;
    self.maxWidth = maxWidth;
    self.minHeight = minHeight;
    self.time = time;
}
-(void)postToastWithMessage:(NSString *)message{
    if (!_active) {
        [self showToast:message];
    }
}
-(void)showToast:(NSString *)str{
    self.active = YES;
    self.bgColor = _bgColor ? _bgColor:[UIColor blackColor];
    self.titleFont = _titleFont ? _titleFont : ToastFont;
    self.titleColor = _titleColor ? _titleColor : [UIColor whiteColor];
    self.maxWidth = _maxWidth ? _maxWidth : ToastMaxW;
    self.minHeight =_minHeight ? _minHeight :ToastH;
    self.time = _time ? _time : ToastTime;
    self.myToastView = [[ToastView alloc]initWithToastStyleWithBgColor:self.bgColor andFont:self.titleFont andTextColor:self.titleColor andToastViewMaxWidth:self.maxWidth andTosrViewMinHeight:self.minHeight];
    self.myToastView.alpha = 0.0f;
    [[UIApplication sharedApplication].keyWindow addSubview:self.myToastView];
    [self.myToastView setMessageText:str];
    CGFloat W = [UIScreen mainScreen].bounds.size.width;
    CGFloat H = [UIScreen mainScreen].bounds.size.height;
    self.myToastView.center = CGPointMake(MIN(W, H)/2.0,MAX(W, H)/2.0);
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.myToastView.alpha = 0.8;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.myToastView.alpha = 0;
                [weakSelf.myToastView removeFromSuperview];
                weakSelf.myToastView = nil;
                weakSelf.active = NO;
            }];
        });
    }];
}
@end
