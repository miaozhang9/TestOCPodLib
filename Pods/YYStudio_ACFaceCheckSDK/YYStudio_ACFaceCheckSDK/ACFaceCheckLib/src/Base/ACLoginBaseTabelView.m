//
//  PCLoginBaseTabelView.m
//  PersonalCenter
//
//  Created by 黄世光 on 2017/5/27.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACLoginBaseTabelView.h"

@implementation ACLoginBaseTabelView

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
