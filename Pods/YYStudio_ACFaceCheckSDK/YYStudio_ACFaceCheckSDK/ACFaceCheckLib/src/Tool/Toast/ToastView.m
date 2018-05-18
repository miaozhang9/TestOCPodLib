//
//  ToastView.m
//  ToastDemo
//
//  Created by 黄世光 on 2016/11/23.
//  Copyright © 2016年 黄世光. All rights reserved.
//

#import "ToastView.h"
@interface ToastView(){
    CGRect messageRect;
    CGRect selfRect;
}
@property(nonatomic,strong)NSString *text;
@property(nonatomic,strong)UILabel *showLab;

@property (nonatomic,assign)CGFloat titleFont;
@property (nonatomic,assign)CGFloat maxWidth;
@property (nonatomic,assign)CGFloat minHeight;
@end
@implementation ToastView
-(instancetype)initWithToastStyleWithBgColor:(UIColor *)bgColor andFont:(CGFloat)titleFont andTextColor:(UIColor *)titleColor andToastViewMaxWidth:(CGFloat)maxWidth andTosrViewMinHeight:(CGFloat)minHeight{
    if (self = [super init]) {
        self.titleFont = titleFont;
        self.minHeight = minHeight;
        self.maxWidth = maxWidth;
        
        self.backgroundColor = bgColor;
        self.clipsToBounds = YES;
        self.showLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.maxWidth, self.minHeight)];
        self.showLab.numberOfLines = 0;
        self.showLab.textAlignment = NSTextAlignmentCenter;
        self.showLab.font = [UIFont systemFontOfSize:self.titleFont];
        self.showLab.textColor = titleColor;
        [self addSubview:self.showLab];
    }
    return self;
}
-(void)setMessageText:(NSString *)message{
    self.showLab.text = message;
    UIFont *textFont = [UIFont systemFontOfSize:self.titleFont];
    CGFloat titleH = [self getHeightthWithStr:message andFont:textFont];
    CGFloat titleW = [self getWidthWithStr:message andFont:textFont];
    if (titleH > ceilf(textFont.lineHeight)) {

        //长度
        selfRect.size.width = self.maxWidth;
        messageRect.size.width = self.maxWidth-40;
        //高度
        selfRect.size.height = titleH + (self.minHeight-textFont.lineHeight);
        messageRect.size.height = titleH;
        //y坐标
        messageRect.origin.y = (self.minHeight-textFont.lineHeight)*0.5;
    }else{
        //长度
        selfRect.size.width = titleW + 40;
        messageRect.size.width = titleW;
        //高度
        messageRect.size.height = textFont.lineHeight;
        selfRect.size.height = self.minHeight;
        //y 坐标
        messageRect.origin.y = (self.minHeight-textFont.lineHeight)*0.5;
    }
    
    selfRect.origin.x = 0;
    selfRect.origin.y = 0;
    messageRect.origin.x = 20;
    self.bounds = selfRect;
    self.layer.cornerRadius = selfRect.size.height*0.1;
    self.showLab.frame = messageRect;
}
-(float)getHeightthWithStr:(NSString *)str andFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.maxWidth-40, MAXFLOAT)];
    label.text = str;
    label.numberOfLines = 0;
    label.font = font;
    [label sizeToFit];
    return label.bounds.size.height;
}
-(float)getWidthWithStr:(NSString *)str andFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MAXFLOAT, font.lineHeight)];
    label.text = str;
    label.font = font;
    [label sizeToFit];
    return label.bounds.size.width;
}
@end
