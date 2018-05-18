//
//  PCCustomScrollView.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/10/31.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACCustomScrollView.h"

@implementation ACCustomScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    
    [[self nextResponder] touchesBegan:touches withEvent:event];
    
    [super touchesBegan:touches withEvent:event];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event

{
    
    [[self nextResponder] touchesEnded:touches withEvent:event];
    
    [super touchesEnded:touches withEvent:event];}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event

{
    
    [[self nextResponder] touchesMoved:touches withEvent:event];
    
    [super touchesMoved:touches withEvent:event];
    
}

@end
