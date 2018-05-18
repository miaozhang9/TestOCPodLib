//
//  ZYTFileDTO.h
//  ZYT
//
//  Created by 易愿 on 16/8/24.
//  Copyright © 2016年 xujialiang. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString const *kImageJPG;

@interface CDZYTFileDTO : NSObject

@property (nonatomic, copy) NSString *fileName; // 文件名称

@property (nonatomic, assign) NSSearchPathDirectory rootPathDirectory; // 根目枚举
@property (nonatomic, copy) NSString *filePath; // 文件相对路径
@property (nonatomic, copy) NSString *fileType; // 文件类型
@property (nonatomic, strong) NSData *fileData; // 文件数据

- (NSString *)fileAbsolutePath;

@end
