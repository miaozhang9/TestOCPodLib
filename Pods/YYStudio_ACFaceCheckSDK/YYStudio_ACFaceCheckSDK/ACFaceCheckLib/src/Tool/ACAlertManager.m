//
//  PCAlertManager.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/5/24.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACAlertManager.h"

@interface ACAlertManager ()


@end

@implementation ACAlertManager

+ (instancetype)shareAlertManager {
    static ACAlertManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ACAlertManager alloc] init];
    });
    return manager;
}

- (void)showAlertMessageWithContent:(NSString *)content {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:content preferredStyle:(UIAlertControllerStyleAlert)];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:YES completion:nil ];
    }]];
    [[self getCurrentVC] presentViewController:alertVC animated:YES completion:nil];
}
- (void)showAlertMessageWithOneContent:(NSString *)content actiontitle:(NSString *)title okeyAction:(ActionBlock)okeyAction{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:content preferredStyle:(UIAlertControllerStyleAlert)];
    title = title.length > 0 ? title : @"确定";
    [alertVC addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (okeyAction) {
            okeyAction();
        }
        [alertVC dismissViewControllerAnimated:YES completion:nil ];
    }]];
    [[self getCurrentVC] presentViewController:alertVC animated:YES completion:nil];
}
- (void)showAlertMessageWithContent:(NSString *)content okeyAction:(ActionBlock)okeyAction cancelAction:(ActionBlock)cancelAction {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:content preferredStyle:(UIAlertControllerStyleAlert)];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (okeyAction) {
            okeyAction();
        }
        [alertVC dismissViewControllerAnimated:YES completion:nil ];
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelAction) {
            cancelAction();
        }
        [alertVC dismissViewControllerAnimated:YES completion:nil ];
    }]];
    [[self getCurrentVC] presentViewController:alertVC animated:YES completion:nil];
}


- (void)showAlertMessageWithTitle:(NSString *)title content:(NSString *)content okeyTitle:(NSString *)okeyTitle okeyAction:(ActionBlock)okeyAction cancelTitle:(NSString *)cancelTitle cancelAction:(ActionBlock)cancelAction {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:(UIAlertControllerStyleAlert)];
    okeyTitle = okeyTitle.length > 0 ? okeyTitle : @"确定";
    [alertVC addAction:[UIAlertAction actionWithTitle:okeyTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (okeyAction) {
            okeyAction();
        }
        [alertVC dismissViewControllerAnimated:YES completion:nil ];
    }]];
    if (cancelTitle) {
        cancelTitle = cancelTitle.length > 0 ? cancelTitle : @"点错了";
        [alertVC addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelAction) {
                cancelAction();
            }
            [alertVC dismissViewControllerAnimated:YES completion:nil ];
        }]];
        
    }
    [[self getCurrentVC] presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark - 获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    UIViewController *resultVC;
    resultVC = [self topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}
- (UIViewController *)topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
