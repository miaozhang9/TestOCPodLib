//
//  PCAvailableRequestDTO.m
//  PersonalCenter
//
//  Created by 黄世光 on 2017/8/19.
//  Copyright © 2017年 黄世光. All rights reserved.
//

#import "ACAvailableRequestDTO.h"

#import "ACAvailableListDTO.h"
#import <YYModel/YYModel.h>

@implementation ACAvailableRequestDTO
- (instancetype)init {
    self = [super init];
    if (self) {
        self.methodName = @"/qjj_app/anyloan/appoint/client/availableList";
        self.httpMethod = HttpMethodGet;
    }
    return self;
}

- (void)generateParamWithisPassToday:(NSString *)isPassToday {
    [self generateParamDic:@{@"isPassToday":isPassToday?:@""}];
}

- (id)getResponseByData:(NSDictionary *)dataDic error:(NSError *)error {
    [super getResponseByData:dataDic error:error];
    if (error == NULL) {
        ACAvailableListDTO *dto = [ACAvailableListDTO yy_modelWithDictionary:dataDic];
        return dto;
    }
    return nil;
}

@end
