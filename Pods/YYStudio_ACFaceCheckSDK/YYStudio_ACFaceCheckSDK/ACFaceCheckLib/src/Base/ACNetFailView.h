//
//  PCNetFailView.h
//  PersonalCenter
//
//  Created by guopengwen on 2017/6/1.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACNetFailView;

//要有点击效果则需实现协议方法
@protocol ACNetFailViewDelegate <NSObject>

@optional
- (void)netFailView:(ACNetFailView *)failView didClickGesture:(UITapGestureRecognizer *)tapGesture;

@end

@interface ACNetFailView : UIView

@property (nonatomic, copy) NSString *messageStr;
@property (nonatomic, weak) id<ACNetFailViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end
