//
//  GRAlertSheetViewController.m
//  GammRayFilters
//
//  Created by guopengwen on 2017/7/12.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACAlertSheetViewController.h"

#import <Masonry/Masonry.h>
#import "UIFont+Addtion.h"
#import "UIColor+Addtion.h"

@interface ACAlertSheetViewController ()

@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, strong) UILabel *titleLb;

@property (nonatomic, strong) UILabel *messageLb;

@property (nonatomic, strong) UIButton *okBtn;

@property (nonatomic, strong) UIButton *cancleBtn;

@property (nonatomic, copy) NSString *alertTitle;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) PCAlertSheetAction cancleAction;

@property (nonatomic, copy) PCAlertSheetAction okAction;

@end

@implementation ACAlertSheetViewController

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancleAction:(PCAlertSheetAction)cancleAction okAction:(PCAlertSheetAction)okAction{
    self = [super init];
    if (self) {
        self.alertTitle = title;
        self.message = message;
        self.cancleAction = cancleAction;
        self.okAction = okAction;
        [self initAndModifySubViews];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:20/255.0 green:21/255.0 blue:21/255.0 alpha:0.5];
}

#pragma mark - init UI and Data

- (void)initAndModifySubViews {
    [self.view addSubview:self.alertView];
    self.titleLb = [self createLabelWithTitle:self.alertTitle font:16 color:[UIColor pc_colorWithHexString:@"#333333"]];
    self.messageLb = [self createLabelWithTitle:self.message font:16 color:[UIColor pc_colorWithHexString:@"#949494"]];
    self.cancleBtn = [self createButtonWithTItle:@"点错了" color:[UIColor pc_colorWithHexString:@"#D6AD74"] action:@selector(clickCancleButton)];
    self.okBtn = [self createButtonWithTItle:@"确定" color:[UIColor pc_colorWithHexString:@"#FFFFFF"] action:@selector(clickDeleteButton)];
    CGFloat alertHeight = 270;
    
    if (_message.length == 0) {
        alertHeight = 220;
    }
    
    if (_alertTitle.length == 0 && _message.length == 0) {
        alertHeight = 170;
    }
    __weak typeof(self) weakSelf = self;
    [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(alertHeight);
    }];
    
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(28);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    
    [_messageLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLb.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(weakSelf.titleLb);
        make.right.mas_equalTo(weakSelf.titleLb);
    }];
    
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(48);
    }];
    
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.cancleBtn.mas_top).mas_offset(-20);
        make.left.mas_equalTo(weakSelf.cancleBtn);
        make.right.mas_equalTo(weakSelf.cancleBtn);
        make.height.mas_equalTo(48);
    } ];
    
    _messageLb.numberOfLines = 2;
    _titleLb.numberOfLines = 2;
    
    _cancleBtn.layer.borderColor = [UIColor pc_colorWithHexString:@"#D6AD74"].CGColor;
    _cancleBtn.layer.borderWidth = 0.5;
    _cancleBtn.layer.cornerRadius = 25;
    
    _okBtn.layer.borderColor = [UIColor pc_colorWithHexString:@"#D6AD74"].CGColor;
    _okBtn.layer.cornerRadius = 25;
    _okBtn.layer.borderWidth = 0.5;
    _okBtn.backgroundColor = [UIColor pc_colorWithHexString:@"#D6AD74"];
}

- (UIButton *)createButtonWithTItle:(NSString *)title color:(UIColor *)color action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:btn];
    return btn;
}

- (UILabel *)createLabelWithTitle:(NSString *)title font:(CGFloat)size color:(UIColor*)color {
    UILabel *lb = [[UILabel alloc] init];
    lb.font = [UIFont pingFangSCRegularWithSize:size];
    lb.textColor = color;
    lb.text = title;
    lb.textAlignment = NSTextAlignmentCenter;
    [self.alertView addSubview:lb];
    return lb;
}

- (UIView *)alertView {
    if (!_alertView) {
        self.alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
    }
    return _alertView;
}

#pragma mark - pravite

- (void)clickDeleteButton {
      if (_okAction) {
        _okAction(self);
    }
    //删除  5s8.0系统会Crash
//    [self dismissAlertSheet];

}

- (void)clickCancleButton {
    [self dismissAlertSheet];
    if (_cancleAction) {
        _cancleAction(self);
    }
}

#pragma mark - public

- (void)presentAlertSheetWithController:(UIViewController *)viewController {
    [viewController.view addSubview:self.view];
    [viewController addChildViewController:self];
    [self didMoveToParentViewController:viewController];
    
    CGRect mainrect = viewController.view.bounds;
    CGRect newRect = CGRectMake(0, mainrect.size.height, mainrect.size.width, mainrect.size.height);
    
    self.view.frame = newRect;
    self.view.frame = mainrect;
}

- (void)dismissAlertSheet {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - getter and setter

- (void)setCancleTitle:(NSString *)cancleTitle {
    _cancleTitle = cancleTitle;
    [_cancleBtn setTitle:_cancleTitle forState:UIControlStateNormal];
}

- (void)setOkTitle:(NSString *)okTitle {
    _okTitle = okTitle;
     [_okBtn setTitle:_okTitle forState:UIControlStateNormal];
}

@end
