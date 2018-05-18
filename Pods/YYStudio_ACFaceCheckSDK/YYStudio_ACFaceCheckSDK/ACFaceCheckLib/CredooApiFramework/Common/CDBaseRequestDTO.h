//
//  BaseRequestForAuth.h
//  DataYesDrJ
//
//  Created by jia.wang on 14/11/27.
//  Copyright (c) 2014年 jia.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CDHttpErrorCodeHandler.h"

typedef enum{
    SecurityType_None = 0,
    SecurityType_UserMustLogin = 2
}SecurityType;

@interface CDBaseRequestDTO : NSObject

@property (strong, nonatomic) NSString              *methodName;
@property (retain, nonatomic) NSMutableDictionary   *paramDic;
@property (assign, nonatomic) BOOL                  useCache; //下载前判断本地是否已有缓存
@property (assign, nonatomic) SecurityType          securityType; //用户登录类型
@property (nonatomic,assign)  NSInteger             serverUrlType;

-(void)generateCommonParamDic;
-(void)generateParamDic:(NSDictionary *)param;

-(void)generateSign;
-(void)generateUploadSign;

-(id)getResponseByData:(id)dataDic error:(NSError **)error;

@end

