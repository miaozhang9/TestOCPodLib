//
//  UIColor+Addtion.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/5/15.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Addtion)

+ (UIColor *)pc_colorWithHex:(NSInteger)hex;

+ (UIColor *)pc_colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)pc_colorWithHexString:(NSString *)color;

+ (UIColor *)pc_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
