//
//  CredooApiFramework.h
//  CredooApiFramework
//
//  Created by 徐佳良 on 16/11/2.
//  Copyright © 2016年 Credoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CredooApiFrameworkConst.h"
#import "CDBaseRequestDTO.h"
#import "CDBaseAuthService.h"
#import "CDFileDTO.h"
#import "CDResponseDTO.h"
#import "CDFileUtil.h"
#import "CDHttpErrorCodeHandler.h"
#import "CDAuthRequestQueue.h"
#import "CDBaseRequestDTOForAuth.h"
#import "CDHttpReqestForAuth.h"
#import "CDBaseHttpRequest.h"
#import "CDBaseRequestDTO.h"
#import "CDBaseRequestQueue.h"
#import "CDPostHttpRequest.h"
#import "UIDevice+Credoo.h"

@interface CredooApiFramework : NSObject

@property (nonatomic,copy) NSArray *httpRequestUrls;
@property (nonatomic,copy) NSString *httpSignPrefix;
@property (nonatomic,copy) NSString *httpSignSurfix;

+(CredooApiFramework *)sharedInstance;

-(void)setHttpBaseUrl:(NSArray *)baseUrls withSignPrefix:(NSString *)prefix withHttpSignSurfix:(NSString *)surfix;

@end
