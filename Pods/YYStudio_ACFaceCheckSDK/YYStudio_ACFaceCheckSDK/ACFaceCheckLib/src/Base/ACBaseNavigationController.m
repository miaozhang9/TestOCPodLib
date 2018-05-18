//
//  BaseNavigationController.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/5/15.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACBaseNavigationController.h"
#import "UIImage+Addtion.h"
#import "UIColor+Addtion.h"
#import "ACAppConstant.h"
#import "ACFaceCheckHelper.h"
@interface ACBaseNavigationController ()

@end

@implementation ACBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBackgroundColor:[UIColor pc_colorWithHexString:[ACFaceCheckHelper share].barColor?[ACFaceCheckHelper share].barColor:@"#FFFFFF"]];
    self.navigationBar.barTintColor = [UIColor pc_colorWithHexString:[ACFaceCheckHelper share].barColor?[ACFaceCheckHelper share].barColor:@"#FFFFFF"];
    [self removeNavBarBottomBlackLine];
}


#pragma mark - public

- (void)removeNavBarBottomBlackLine {
    UIImageView *imgView = [self findHairlineImageViewUnder:self.navigationBar];
    imgView.hidden = YES;;
}

- (void)changeNavBarBottomLineColor {
    UIImageView *imgView = [self findHairlineImageViewUnder:self.navigationBar];
    imgView.alpha = 1;
    UIImage *colorImage = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.5)];
    [self.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor pc_colorWithHexString:@"#E5E5E5"] size:CGSizeMake(self.view.frame.size.width, 0.5)]];
}

#pragma mark - pravite

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
