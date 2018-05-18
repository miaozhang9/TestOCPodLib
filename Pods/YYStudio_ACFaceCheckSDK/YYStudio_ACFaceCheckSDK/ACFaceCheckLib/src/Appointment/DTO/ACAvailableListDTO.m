//
//  AvailableDTO.m
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACAvailableListDTO.h"

@implementation ACAvailableListDTO
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"schedules" : [ACAvailableDayDTO class]};
}
@end

@implementation ACAvailableDayDTO
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"slots" : [ACAvailableDTO class]};
}
@end

@implementation ACAvailableDTO


@end
