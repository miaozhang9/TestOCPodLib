//
//  ToastView.h
//  ToastDemo
//
//  Created by 黄世光 on 2016/11/23.
//  Copyright © 2016年 黄世光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastView : UIView

-(instancetype)initWithToastStyleWithBgColor:(UIColor *)bgColor andFont:(CGFloat)titleFont andTextColor:(UIColor *)titleColor andToastViewMaxWidth:(CGFloat)maxWidth andTosrViewMinHeight:(CGFloat) minHeight;;
-(void)setMessageText:(NSString *)message;
@end
