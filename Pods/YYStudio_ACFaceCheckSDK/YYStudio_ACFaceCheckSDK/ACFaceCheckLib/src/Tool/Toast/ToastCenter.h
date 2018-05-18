//
//  ToastCenter.h
//  ToastDemo
//
//  Created by 黄世光 on 2016/11/23.
//  Copyright © 2016年 黄世光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ToastCenter : NSObject
+ (ToastCenter *)defaultCenter;
- (void)postToastWithMessage:(NSString *)message;
//需在显示tost之前设置
-(void)setToastShowTime:(CGFloat)time;
- (void)setToastStyleWithBgColor:(UIColor *)bgColor andFont:(CGFloat)titleFont andTextColor:(UIColor *)titleColor andToastViewMaxWidth:(CGFloat)maxWidth andTosrViewMinHeight:(CGFloat) minHeight andTime:(CGFloat)time;
@end
