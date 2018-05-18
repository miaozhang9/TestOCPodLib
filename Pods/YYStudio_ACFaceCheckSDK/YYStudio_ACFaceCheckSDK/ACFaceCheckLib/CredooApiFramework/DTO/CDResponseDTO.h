//
//  CDResponseDTO.h
//  CredooApiFramework
//
//  Created by 徐佳良 on 2016/11/3.
//  Copyright © 2016年 Credoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDResponseDTO : NSObject

@property (nonatomic,copy) NSString *code; //业务级 错误代码
@property (nonatomic,copy) NSString *message; // 错误提示
@property (nonatomic,copy) NSDictionary *data; // 数据
@property (nonatomic,copy) NSDictionary *headers; // 数据
@property (nonatomic,copy) NSDictionary *result; // 数据

@end
