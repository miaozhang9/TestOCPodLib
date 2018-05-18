//
//  PCUserAuthDTO.m
//  PersonalCenter
//
//  Created by guopengwen on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "PCUserAuthDTO.h"

#import <YYModel/YYModel.h>

@implementation PCUserAuthDTO

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.yy_modelToJSONString forKey:NSStringFromClass([PCUserAuthDTO class])];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [PCUserAuthDTO yy_modelWithJSON:[aDecoder decodeObjectForKey:NSStringFromClass([PCUserAuthDTO class])]];
    if (self) {
    }
    return self;
}

- (id)checkEncodeObject:(id)object {
    return object == nil ? [NSNull null] : object;
}

- (id)checkDecodeObject:(id)obj {
    return [obj isKindOfClass:[NSNull class]] ? nil : obj;
}

@end
