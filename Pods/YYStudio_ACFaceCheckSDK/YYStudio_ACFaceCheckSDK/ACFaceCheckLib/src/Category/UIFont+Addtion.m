//
//  UIFont+Addtion.m
//  GammRayFilters
//
//  Created by guopengwen on 2017/7/6.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "UIFont+Addtion.h"

@implementation UIFont (Addtion)

+ (UIFont *)pingFangSCMediumWithSize:(CGFloat)size  {
    CGFloat phoneVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (phoneVersion >= 9.0) {
        return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
    }
    return [UIFont systemFontOfSize:size];
}

+ (UIFont *)pingFangSCRegularWithSize:(CGFloat)size {
    CGFloat phoneVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (phoneVersion >= 9.0) {
        return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    }
    return [UIFont systemFontOfSize:size];
}

@end
