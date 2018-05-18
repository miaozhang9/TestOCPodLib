//
//  UIView+Addtion.m
//  ACFaceCheckLib
//
//  Created by 郭阳阳(金融壹账通客户端研发团队) on 2018/2/5.
//  Copyright © 2018年 Miaoz. All rights reserved.
//

#import "UIView+Addtion.h"

@implementation UIView (Addtion)

- (void)pc_removeAllSubviews {
    //[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

@end
